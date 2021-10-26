//
//  NSLayoutConstraint+Extensions.swift
//  AppStoreSearch-SHOH
//
//  Created by Jayden OH on 2021/10/23.
//

import UIKit

extension NSLayoutConstraint {
    func changeMultiplier(_ multiplier: CGFloat) -> NSLayoutConstraint {
        self.isActive = false
        
        let newConstraint = NSLayoutConstraint(
            item: self.firstItem as Any,
            attribute: self.firstAttribute,
            relatedBy: self.relation,
            toItem: self.secondItem,
            attribute: self.secondAttribute,
            multiplier: multiplier,
            constant: self.constant
        )
        
        newConstraint.priority = self.priority
        newConstraint.shouldBeArchived = self.shouldBeArchived
        newConstraint.identifier = self.identifier
        
        newConstraint.isActive = true
        return newConstraint
    }
}
