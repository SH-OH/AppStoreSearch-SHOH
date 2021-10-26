//
//  IBView.swift
//  AppStoreSearch-SHOH
//
//  Created by Jayden OH on 2021/10/25.
//

import UIKit.UIView

class IBButton: UIButton {
    @IBInspectable var cornerRadius: CGFloat {
        get { return layer.cornerRadius }
        set {
            layer.cornerRadius = newValue
            layer.masksToBounds = true
        }
    }
    @IBInspectable var borderWidth: CGFloat {
        get { return layer.borderWidth }
        set { layer.borderWidth = newValue }
    }
    @IBInspectable var borderColor: UIColor {
        get { return UIColor(cgColor: layer.borderColor!) }
        set { layer.borderColor = newValue.cgColor }
    }
}

class IBImageView: UIImageView {
    @IBInspectable var cornerRadius: CGFloat {
        get { return layer.cornerRadius }
        set {
            layer.cornerRadius = newValue
            layer.masksToBounds = true
        }
    }
    @IBInspectable var borderWidth: CGFloat {
        get { return layer.borderWidth }
        set { layer.borderWidth = newValue }
    }
    @IBInspectable var borderColor: UIColor {
        get { return UIColor(cgColor: layer.borderColor!) }
        set { layer.borderColor = newValue.cgColor }
    }
}

class IBView: UIView {
    @IBInspectable var cornerRadius: CGFloat {
        get { return layer.cornerRadius }
        set {
            layer.cornerRadius = newValue
            layer.masksToBounds = true
        }
    }
    @IBInspectable var borderWidth: CGFloat {
        get { return layer.borderWidth }
        set { layer.borderWidth = newValue }
    }
    @IBInspectable var borderColor: UIColor {
        get { return UIColor(cgColor: layer.borderColor!) }
        set { layer.borderColor = newValue.cgColor }
    }
     @IBInspectable var setGradient: UIColor {
        get { return backgroundColor ?? UIColor.white }
        set { setGradient(newValue) }
    }
    
    private func setGradient(_ gradientColor: UIColor) {
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
