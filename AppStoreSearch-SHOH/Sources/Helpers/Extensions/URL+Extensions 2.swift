//
//  URL+Extensions.swift
//  AppStoreSearch-SHOH
//
//  Created by Jayden OH on 2021/10/25.
//

import Foundation
import UIKit.UIApplication

extension URL {
    func openURL() {
        if UIApplication.shared.canOpenURL(self) {
            UIApplication.shared.open(self)
        }
    }
}
