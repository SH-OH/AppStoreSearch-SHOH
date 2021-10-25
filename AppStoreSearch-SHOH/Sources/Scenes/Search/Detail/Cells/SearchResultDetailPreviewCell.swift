//
//  SearchResultDetailPreviewCell.swift
//  AppStoreSearch-SHOH
//
//  Created by Jayden OH on 2021/10/23.
//

import UIKit

final class SearchResultDetailPreviewCell: UICollectionViewCell {
    
    @IBOutlet private weak var screenshotImageView: UIImageView!
    @IBOutlet private weak var imageViewAspect: NSLayoutConstraint!
    
    func configure(_ url: String?, screenshotType: ScreenshotType) {
        if screenshotType == .wide {
            imageViewAspect = imageViewAspect.changeMultiplier(screenshotType.multiplier)
            screenshotImageView.layoutIfNeeded()
        }
        
        screenshotImageView.setImage(with: url)
    }
}
