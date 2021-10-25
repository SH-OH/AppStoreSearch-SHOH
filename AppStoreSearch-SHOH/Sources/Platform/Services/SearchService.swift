//
//  SearchService.swift
//  AppStoreSearch-SHOH
//
//  Created by Jayden OH on 2021/10/21.
//

import Foundation

enum SearchService {
    enum CountryType: String {
        case KR
    }
    
    case getSearchList(
        term: String,
        limit: Int,
        country: CountryType
    )
}

extension SearchService: TargetType {
    var baseURL: URL {
        return URL(string: Domain.ItunesStore.url)!
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
        case let .getSearchList(term, limit, country):
            params["term"] = term
            params["limit"] = limit
            params["entity"] = "software"
            params["country"] = country.rawValue
            return .requestParameters(parameters: params, encoding: .URLEncoding)
        }
    }
    
    var headers: [String : String]? {
        return nil
    }
    
}
