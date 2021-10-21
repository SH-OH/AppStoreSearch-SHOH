//
//  Cachable.swift
//  AppStoreSearch-SHOH
//
//  Created by Jayden OH on 2021/10/21.
//

import UIKit.UIImage

protocol Cachable {
    var cacheCost: Int { get }
}

extension UIImage: Cachable {
    var cacheCost: Int {
        let pixel = Int(size.width * size.height * scale * scale)
        guard let cgImage = cgImage else {
            return pixel * 4
        }
        return pixel * cgImage.bitsPerPixel / 8
    }
}
