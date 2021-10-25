//
//  ScreenshotType.swift
//  AppStoreSearch-SHOH
//
//  Created by Jayden OH on 2021/10/25.
//

import CoreGraphics

enum ScreenshotType {
    case high
    case wide
    
    var multiplier: Double {
        switch self {
        case .high:
            return 392.0/696.0
        case .wide:
            return 406.0/228.0
        }
    }
}
