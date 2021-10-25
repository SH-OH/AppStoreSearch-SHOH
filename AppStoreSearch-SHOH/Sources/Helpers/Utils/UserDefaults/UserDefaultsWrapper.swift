//
//  UserDefaultsWrapper.swift
//  AppStoreSearch-SHOH
//
//  Created by Jayden OH on 2021/10/25.
//

import Foundation

@propertyWrapper
struct UserDefaultsWrapper<T> {
    private let key: UserDefaultsStorage.Key
    private let defaultValue: T
    private let userDefaults: UserDefaults
    
    init(key: UserDefaultsStorage.Key, defaultValue: T, userDefaults: UserDefaults = .standard) {
        self.key = key
        self.defaultValue = defaultValue
        self.userDefaults = userDefaults
    }
    
    var wrappedValue: T {
        get {
            guard let value = userDefaults.object(forKey: key.rawValue) as? T else {
                return self.key.ioQueue.sync(execute: { return defaultValue })
            }
            return self.key.ioQueue.sync(execute: { return value })
        }
        set {
            self.key.ioQueue.async { [self] in
                if let optionalValue = (newValue as? Optionalable), optionalValue.isNil {
                    self.userDefaults.removeObject(forKey: self.key.rawValue)
                } else {
                    self.userDefaults.setValue(newValue, forKey: self.key.rawValue)
                }
            }
        }
    }
}
