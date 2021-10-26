//
//  UINavigationBarAppearance+Extensions.swift
//  AppStoreSearch-SHOH
//
//  Created by Jayden OH on 2021/10/25.
//

import UIKit

extension UINavigationBarAppearance {
    enum ConfigType {
        case `default`, opaque, transparent
    }
    
    static func create(
        configType: ConfigType,
        backgroundColor: UIColor,
        hasBottomLine: Bool
    ) -> UINavigationBarAppearance {
        let appearance = UINavigationBarAppearance()
        switch configType {
        case .default:
            appearance.configureWithDefaultBackground()
        case .opaque:
            appearance.configureWithOpaqueBackground()
        case .transparent:
            appearance.configureWithTransparentBackground()
        }
        appearance.shadowImage = hasBottomLine ? nil : UIImage()
        return appearance
    }
}
