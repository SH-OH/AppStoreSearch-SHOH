//
//  UIView+Extensions.swift
//  AppStoreSearch-SHOH
//
//  Created by Jayden OH on 2021/10/23.
//

import UIKit

extension UIView {
    func setGradient(_ gradientColor: UIColor) {
        let colors: [UIColor] = [
            gradientColor.withAlphaComponent(0.25),
            gradientColor.withAlphaComponent(1)
        ]
        
        let leftToRightGrad: CAGradientLayer = .init()
        leftToRightGrad.frame = self.bounds
        leftToRightGrad.startPoint = CGPoint(x: 0, y: 1)
        leftToRightGrad.endPoint = CGPoint(x: 1, y: 1)
        leftToRightGrad.colors = colors.map { $0.cgColor }
        leftToRightGrad.shouldRasterize = true
        
        self.layer.addSublayer(leftToRightGrad)
    }
}
