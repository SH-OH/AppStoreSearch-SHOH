//
//  Domain.swift
//  AppStoreSearch-SHOH
//
//  Created by Jayden OH on 2021/10/21.
//

import Foundation

enum Domain {
    case ItunesStore
    case AppStore
    
    var url: String {
        switch self {
        case .ItunesStore:
            return "https://itunes.apple.com"
        
        case .AppStore:
            return "itms-apps://apple.com/app"
        }
    }
}

extension Domain {
    static func review(id: Int) -> String {
        return Domain.AppStore.url + "/app/itunes-u/id\(id)?ls=1&mt=8&action=write-review"
    }
}
