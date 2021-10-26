//
//  UserDefaultsStorage.swift
//  AppStoreSearch-SHOH
//
//  Created by Jayden OH on 2021/10/25.
//

import Foundation

import RxSwift

struct UserDefaultsStorage {
    enum Key: String {
        case RecentSearchKeywords
        
        var ioQueue: DispatchQueue {
            return DispatchQueue(label: "ioQueue.UserDefaultsStorage.\(self)", qos: .utility)
        }
    }
    
    @UserDefaultsWrapper(key: .RecentSearchKeywords, defaultValue: [])
    static var recentSearchKeywords: [String]
}

extension UserDefaultsStorage {
    static func updateRecentSearchKeywords(_ keyword: String) {
        var newKeywords = recentSearchKeywords
        
        if newKeywords.contains(keyword) {
            if let index = newKeywords.firstIndex(of: keyword) {
                newKeywords.remove(at: index)
            }
        }
        
        newKeywords.insert(keyword, at: 0)
        
        self.recentSearchKeywords = newKeywords
    }
}
