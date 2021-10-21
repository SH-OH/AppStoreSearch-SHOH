//
//  ImageLoader.swift
//  AppStoreSearch-SHOH
//
//  Created by Jayden OH on 2021/10/20.
//

import Foundation
import UIKit.UIImage

typealias ImageLoaderBlock = (Result<UIImage?, ImageLoader.ImageError>) -> Void

final class ImageLoader {
    enum ImageError: Error {
        case invalidURL(_ imageUrl: String)
        case networkError(_ error: Error)
        case unknown
    }
    
    private enum QueueType {
        case main
        case imageProcess
        case cache
        
        func excute(_ block: @escaping () -> Void) {
            switch self {
            case .main:
                DispatchQueue.main.async(execute: block)
            case .imageProcess:
                DispatchQueue(label: "ImageLoader.imageProcess").async(execute: block)
            case .cache:
                DispatchQueue(label: "ImageLoader.imageCache").async(execute: block)
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
    
    func load(
        _ imageUrl: String,
        completion: @escaping ImageLoaderBlock
    ) -> URLSessionDataTask? {
        if let cachedImage = imageCache.getImage(imageUrl) {
            QueueType.main.excute {
                completion(.success(cachedImage))
            }
            return nil
        } else {
            let dataTask = createTask(imageUrl) { result in
                QueueType.main.excute {
                    completion(result)
                }
            }
            dataTask?.resume()
            return dataTask
        }
    }
}

extension ImageLoader {
    private func createTask(
        _ imageUrl: String,
        completion: @escaping ImageLoaderBlock
    ) -> URLSessionDataTask? {
        guard let url = URL(string: imageUrl) else {
            completion(.failure(.invalidURL(imageUrl)))
            return nil
        }
        
        let request = URLRequest(
            url: url,
            cachePolicy: .reloadIgnoringLocalCacheData,
            timeoutInterval: self.timeout
        )
        
        let newDataTask = self.session.dataTask(with: request) { [weak self] data, response, error in
            guard let httpResponse = response as? HTTPURLResponse,
                  (200...399).contains(httpResponse.statusCode) else {
                      completion(.failure(.networkError(error ?? ImageError.unknown)))
                      return
                  }
            
            if let data = data {
                self?.processImage(data, imageUrl: imageUrl) { image in
                    completion(.success(image))
                }
                return
            }
            
            completion(.failure(.unknown))
        }
        
        return newDataTask
    }
    
    private func processImage(
        _ data: Data,
        imageUrl: String,
        completion: @escaping (UIImage?) -> Void
    ) {
        QueueType.imageProcess.excute { [weak self] in
            let image = UIImage(data: data)
            if let image = image {
                QueueType.cache.excute { [weak self] in
                    self?.imageCache.setImage(imageUrl, image: image)
                }
            }
            completion(image)
        }
    }
}
