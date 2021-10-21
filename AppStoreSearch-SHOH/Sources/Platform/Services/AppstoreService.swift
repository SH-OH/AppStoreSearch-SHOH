//
//  AppstoreService.swift
//  AppStoreSearch-SHOH
//
//  Created by Jayden OH on 2021/10/21.
//

import Foundation

enum AppstoreService {
    enum CountryType: String {
        case KR
    }
    
    case getSearchList(
        term: String,
        entity: String,
        country: CountryType
    )
}

extension AppstoreService: TargetType {
    var baseURL: URL {
        return URL(string: Domain.AppStore.url)!
    }
    
    var path: String {
        switch self {
        case .getSearchList:
            return "/search"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .getSearchList:
            return .get
        }
    }
    
    var sampleData: Data {
        switch self {
        case .getSearchList:
            return .init()
        }
    }
    
    var task: Task {
        var params: [String: Any] = [:]
        switch self {
        case let .getSearchList(term, entity, country):
            params["term"] = term
            params["entity"] = entity
            params["country"] = country.rawValue
            return .requestParameters(parameters: params, encoding: .URLEncoding)
        }
    }
    
    var headers: [String : String]? {
        return nil
    }
    
}
