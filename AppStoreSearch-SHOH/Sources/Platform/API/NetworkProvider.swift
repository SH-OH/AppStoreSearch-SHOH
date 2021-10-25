//
//  NetworkProvider.swift
//  AppStoreSearch-SHOH
//
//  Created by Jayden OH on 2021/10/21.
//

import Foundation

import RxSwift

final class NetworkProvider<Target: TargetType> {
    enum APIError: Error {
        case networkError(_ error: Error)
        case paredFail(_ error: Error)
        case unknown
    }
    
    private let session: URLSessionProtocol
    private let defaultQueue: DispatchQueue
    private let decoder: JSONDecoder = {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        return decoder
    }()
    
    init(
        session: URLSessionProtocol = URLSession.shared,
        defaultQueue: DispatchQueue? = nil
    ) {
        self.session = session
        self.defaultQueue = defaultQueue ?? DispatchQueue(label: "NetworkProvider.default", qos: .utility)
    }
    
    func request<D: Decodable>(
        _ modelType: D.Type,
        target: Target,
        callbackScheduler: ImmediateSchedulerType = MainScheduler.asyncInstance
    ) -> Single<D> {
        return Single<D>.create { [weak self] observer in
            let disposable = Disposables.create()
            guard let self = self else { return disposable }
            let url = self.configURL(by: target)
            
            ActivityIndicator.shared.show()
            
            var request = URLRequest(url: url)
            request.httpMethod = target.method.rawValue
            request.allHTTPHeaderFields = target.headers
            request = request.configTask(by: target.task)
            
            let task = self.session
                .dataTask(with: request) { [weak self] data, response, error in
                    guard let httpResponse = response as? HTTPURLResponse,
                          (200...399).contains(httpResponse.statusCode) else {
                              observer(.failure(APIError.networkError(error ?? APIError.unknown)))
                              return
                          }
                    
                    if let data = data {
                        do {
                            if let result = try self?.decoder.decode(modelType.self, from: data) {
                                observer(.success(result))
                            }
                        } catch {
                            observer(.failure(APIError.paredFail(error)))
                        }
                        
                        return
                    }
                    observer(.failure(APIError.unknown))
                }
            
            task.resume()
            
            return Disposables.create {
                task.cancel()
            }
        }
        .subscribe(on: ConcurrentDispatchQueueScheduler(queue: self.defaultQueue))
        .observe(on: callbackScheduler)
        .do(onDispose: {
            ActivityIndicator.shared.hide()
        })
    }
}

extension NetworkProvider {
    private func configURL(by target: Target) -> URL {
        let path = target.path
        if path.isEmpty {
            return target.baseURL
        } else {
            return target.baseURL.appendingPathComponent(path)
        }
    }
}
