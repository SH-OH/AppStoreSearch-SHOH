//
//  SearchResultReviewCell.swift
//  AppStoreSearch-SHOH
//
//  Created by Jayden OH on 2021/10/23.
//

import UIKit

final class SearchResultReviewCell: UICollectionViewCell {
    struct Dependency {
        let ratingDouble: Double
        let userRatingCount: Int
        let writeReviewUrl: String
        let sellerUrl: String
        let title: String
        let updateDateToAgo: Date
        let reviewContents: String
        let rating: Double
        let ratingArray: [Double]
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
}
