//
//  SearchResultDetailViewController.swift
//  AppStoreSearch-SHOH
//
//  Created by Jayden OH on 2021/10/23.
//

import UIKit

import SPMSHOHProxy
import ReactorKit

final class SearchResultDetailViewController: UIViewController, StoryboardLoadable {
    
    var disposeBag: DisposeBag = .init()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
}

extension SearchResultDetailViewController: StoryboardView {
    func bind(reactor: SearchResultDetailViewReactor) {
        
    }
}
