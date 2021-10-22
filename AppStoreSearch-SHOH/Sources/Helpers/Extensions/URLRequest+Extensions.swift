//
//  URLRequest+Extensions.swift
//  AppStoreSearch-SHOH
//
//  Created by Jayden OH on 2021/10/22.
//

import Foundation

extension URLRequest {
    func configTask(by task: Task) -> URLRequest {
        switch task {
        case .requestPlain:
            return self
        case let .requestParameters(parameters, encoding):
            switch encoding {
            case .URLEncoding:
                guard let encodedUrlString = self.url?.absoluteString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
                      let encodedUrl = URL(string: encodedUrlString),
                      !parameters.isEmpty else {
                          return self
                      }
                
                if var components = URLComponents(url: encodedUrl, resolvingAgainstBaseURL: false) {
                    let query = parameters.map({ "\($0.key)=\($0.value)" }).joined(separator: "&")
                    components.query = query
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
