//
//  ImageCache.swift
//  AppStoreSearch-SHOH
//
//  Created by Jayden OH on 2021/10/20.
//

import Foundation
import UIKit.UIImage

struct ImageCache {
    private enum Const {
        static let name: String = "ImageCache"
    }
    
    private let cache: NSCache<NSString, UIImage>
    private let lock: NSRecursiveLock
    
    init(
        cache: NSCache<NSString, UIImage> = .init(),
        lock: NSRecursiveLock = .init()
    ) {
        self.cache = cache
        self.cache.name = Const.name
        
        self.cache.totalCostLimit = Int.max
        self.cache.countLimit = Int.max
        
        self.lock = lock
        self.lock.name = Const.name
    }
    
    func getImage(_ key: String) -> UIImage? {
        return cache.object(forKey: key as NSString)
    }
    
    func setImage(_ key: String, image: UIImage) {
        self.lock.lock()
        defer { self.lock.unlock() }
        
        cache.setObject(image, forKey: key as NSString, cost: image.cacheCost)
    }
}
