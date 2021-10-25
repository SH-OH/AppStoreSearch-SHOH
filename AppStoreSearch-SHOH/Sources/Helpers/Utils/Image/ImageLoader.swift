//
//  ImageLoader.swift
//  AppStoreSearch-SHOH
//
//  Created by Jayden OH on 2021/10/20.
//

import Foundation
import UIKit.UIImage
import RxSwift

typealias ImageLoaderBlock = (Result<UIImage?, ImageLoader.ImageError>) -> Void

final class ImageLoader {
    enum ImageError: Error {
        case invalidURL(_ imageUrl: String?)
        case networkError(_ error: Error)
        case unknown
    }
    
    private enum QueueType {
        case `default`
        case imageProcess
        case cache
        
        var queue: DispatchQueue {
            switch self {
            case .default:
                return DispatchQueue(label: "ImageLoader.default", qos: .utility)
            case .imageProcess:
                return DispatchQueue(label: "ImageLoader.imageProcess", qos: .userInitiated)
            case .cache:
                return DispatchQueue(label: "ImageLoader.imageCache", qos: .background)
            }
        }
    }
    
    static let shared: ImageLoader = .init()
    
    var imageTaskKey: Void?
    
    private let imageCache: ImageCache
    private let session: URLSessionProtocol
    private var timeout: Double
    
    init(
        imageCache: ImageCache = .init(),
        session: URLSessionProtocol = URLSession(configuration: .ephemeral),
        timeout: Double = 15.0
    ) {
        self.imageCache = imageCache
        self.session = session
        self.timeout = timeout
    }
    
    func load(_ imageUrl: String?) -> Single<UIImage?> {
        return Single<UIImage?>.create { [weak self] observer in
            let disposable = Disposables.create()
            
            guard let self = self else { return disposable }
            guard let imageUrl = imageUrl else {
                observer(.failure(ImageError.invalidURL(imageUrl)))
                return disposable
            }
            
            if let cachedImage = self.imageCache.getImage(imageUrl) {
                observer(.success(cachedImage))
                return disposable
            } else {
                _ = self.createTask(imageUrl)
                    .subscribe(observer)
            }
            
            return disposable
        }
        .subscribe(on: ConcurrentDispatchQueueScheduler(queue: QueueType.default.queue))
        .observe(on: MainScheduler.asyncInstance)
    }
}

extension ImageLoader {
    private func createTask(_ imageUrl: String) -> Single<UIImage?> {
        return Single<UIImage?>.create { [weak self] observer in
            let disposable = Disposables.create()
            guard let self = self else { return disposable }
            guard let url = URL(string: imageUrl) else {
                observer(.failure(ImageError.invalidURL(imageUrl)))
                return disposable
            }
            
            let request = URLRequest(
                url: url,
                cachePolicy: .reloadIgnoringLocalCacheData,
                timeoutInterval: self.timeout
            )
            
            let newDataTask = self.session.dataTask(with: request) { [weak self] data, response, error in
                guard let httpResponse = response as? HTTPURLResponse,
                      (200...399).contains(httpResponse.statusCode) else {
                          observer(.failure(ImageError.networkError(error ?? ImageError.unknown)))
                          return
                      }
                
                if let data = data {
                    self?.processImage(data, imageUrl: imageUrl) { image in
                        observer(.success(image))
                    }
                    return
                }
                
                observer(.failure(ImageError.unknown))
            }
            
            newDataTask.resume()
            
            return Disposables.create {
                newDataTask.cancel()
            }
        }
    }
    
    private func processImage(
        _ data: Data,
        imageUrl: String,
        completion: @escaping (UIImage?) -> Void
    ) {
        QueueType.imageProcess.queue.async { [weak self] in
            let image = UIImage(data: data)
            if let image = image {
                QueueType.cache.queue.async { [weak self] in
                    self?.imageCache.setImage(imageUrl, image: image)
                }
            }
            completion(image)
        }
    }
}
