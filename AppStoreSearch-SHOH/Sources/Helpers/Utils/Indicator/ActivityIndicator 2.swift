//
//  ActivityIndicator.swift
//  AppStoreSearch-SHOH
//
//  Created by Jayden OH on 2021/10/26.
//

import Foundation
import UIKit

final class ActivityIndicator {
    
    static let shared: ActivityIndicator = .init()
    
    private lazy var indicator: UIActivityIndicatorView = {
        let indicator: UIActivityIndicatorView = .init(style: .large)
        indicator.frame = .init(origin: .zero, size: .init(width: 50, height: 50))
        indicator.hidesWhenStopped = true
        indicator.color = .gray
        return indicator
    }()
    
    func show() {
        DispatchQueue.main.async {
            guard let keyWindow = self.findKeyWindow() else { return }
            if !keyWindow.contains(self.indicator) {
                keyWindow.addSubview(self.indicator)
                self.indicator.snp.makeConstraints { make in
                    make.center.equalToSuperview()
                }
                self.indicator.startAnimating()
            }
        }
    }
    
    func hide() {
        DispatchQueue.main.async {
            self.indicator.stopAnimating()
            self.indicator.removeFromSuperview()
        }
    }
    
    private func findKeyWindow() -> UIWindow? {
        return UIApplication.shared.connectedScenes.lazy
            .filter({ $0.activationState == .foregroundActive })
            .compactMap({ $0 as? UIWindowScene })
            .first?.windows
            .filter({ $0.isKeyWindow })
            .first
    }
}
