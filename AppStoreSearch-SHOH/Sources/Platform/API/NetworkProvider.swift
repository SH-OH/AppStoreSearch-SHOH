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
        case invalidURL(_ imageUrl: String)
        case networkError(_ error: Error)
        case paredFail(_ error: Error)
        case unknown
    }
    
    private let session: URLSessionProtocol
    private let timeout: Double
    private let decoder: JSONDecoder = {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        return decoder
    }()
    
    init(
        session: URLSessionProtocol = URLSession.shared,
        timeout: Double = 30.0
    ) {
        self.session = session
        self.timeout = timeout
    }
    
    func request<D: Decodable>(
        _ modelType: D.Type,
        target: Target,
        callbackQueue: DispatchQueue = .main
    ) -> Single<D> {
        return Single<D>.create { [weak self] observer in
            let disposable = Disposables.create()
            guard let self = self else { return disposable }
            let url = self.configURL(by: target)
            
            var request = URLRequest(url: url, timeoutInterval: self.timeout)
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
            
            return Disposables.create()
        }
        .observe(on: ConcurrentDispatchQueueScheduler(queue: callbackQueue))
    }
    
    private func configURL(by target: Target) -> URL {
        let path = target.path
        if path.isEmpty {
            return target.baseURL
        } else {
            return target.baseURL.appendingPathComponent(path)
        }
    }
    
}

extension URLRequest {
    func configTask(by task: Task) -> URLRequest {
        switch task {
        case .requestPlain:
            return self
        case let .requestParameters(parameters, encoding):
            switch encoding {
            case .URLEncoding:
                guard let url = self.url, !parameters.isEmpty else {
                    print("Failed URLEncoding")
                    return self
                }
                if var components = URLComponents(url: url, resolvingAgainstBaseURL: false) {
                    let percentEncodedQuery = (components.percentEncodedQuery.map({ $0 + "&" })) ?? ""
                    let query = parameters.map({ "\($0.key)=\($0.value)" }).joined(separator: "&")
                    
                    components.percentEncodedQuery = percentEncodedQuery + query
                    var newRequest = self
                    newRequest.url = components.url
                    return newRequest
                }
                return self
            case .JSONEncoding:
                do {
                    let data = try JSONSerialization.data(withJSONObject: parameters, options: [])
                    var newRequest = self
                    let contentType = "Content-Type"
                    if newRequest.allHTTPHeaderFields?[contentType] == nil {
                        newRequest.allHTTPHeaderFields?.updateValue("application/json", forKey: contentType)
                    }
                    newRequest.httpBody = data
                    return newRequest
                } catch {
                    print("Failed JSONEncoding : \(error)")
                    return self
                }
            }
        }
    }
}
