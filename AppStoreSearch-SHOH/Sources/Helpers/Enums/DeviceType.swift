//
//  DeviceType.swift
//  AppStoreSearch-SHOH
//
//  Created by Jayden OH on 2021/10/25.
//

import Foundation

enum DeviceType: String {
    case iPhone, iPad, iPod
    
    var title: String {
        switch self {
        case .iPhone:
            return "iPhone"
        case .iPad:
            return "iPad"
        case .iPod:
            return "iPod touch"
        }
    }
    
    var os: String {
        switch self {
        case .iPhone, .iPod:
            return "iOS"
        case .iPad:
            return "iPadOS"
        }
    }
}
