//
//  Domain.swift
//  AppStoreSearch-SHOH
//
//  Created by Jayden OH on 2021/10/21.
//

import Foundation

enum Domain {
    case AppStore
    
    var url: String {
        switch self {
        case .AppStore:
            return "https://itunes.apple.com"
        }
    }
}
