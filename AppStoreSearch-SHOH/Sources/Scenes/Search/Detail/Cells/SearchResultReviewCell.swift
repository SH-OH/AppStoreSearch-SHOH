//
//  SearchResultReviewCell.swift
//  AppStoreSearch-SHOH
//
//  Created by Jayden OH on 2021/10/23.
//

import UIKit

final class SearchResultReviewCell: UICollectionViewCell {
    
    @IBOutlet private weak var gradientView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        gradientView.setGradient(.systemGray5)
    }
}
