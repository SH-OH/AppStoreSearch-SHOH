//
//  SearchRecentCell.swift
//  AppStoreSearch-SHOH
//
//  Created by Jayden OH on 2021/10/22.
//

import UIKit

final class SearchRecentCell: UICollectionViewCell {
    
    @IBOutlet private weak var recentLabel: UILabel!
    
    func configure(text: String) {
        recentLabel.text = text
    }
}
