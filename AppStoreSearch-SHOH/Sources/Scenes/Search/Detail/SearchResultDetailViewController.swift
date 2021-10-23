//
//  SearchResultDetailViewController.swift
//  AppStoreSearch-SHOH
//
//  Created by Jayden OH on 2021/10/23.
//

import UIKit

import SPMSHOHProxy
import ActiveLabel
import ReactorKit

final class SearchResultDetailViewController: UIViewController, StoryboardLoadable {
    
    
    // MARK: - Constraints
    
    @IBOutlet private weak var newFeatureViewHeight: NSLayoutConstraint!
    @IBOutlet private weak var descriptionViewHeight: NSLayoutConstraint!
    /// 최소 height 440, 최대 510 (호환성: +30, 연령등급 +40)
    @IBOutlet private weak var informationViewHeight: NSLayoutConstraint!
    @IBOutlet private weak var supportedViewHeight: NSLayoutConstraint!
    @IBOutlet private weak var contentsRatingViewHeight: NSLayoutConstraint!
    
    // MARK: - UI Components
    
    /// 메인
    @IBOutlet private weak var trackImage: UIImageView!
    @IBOutlet private weak var trackNameLabel: UILabel!
    /// 진입하고 3초 이후 description으로 변경
    @IBOutlet private weak var artistLabel: UILabel!
    @IBOutlet private weak var openButton: UIButton!
    @IBOutlet private weak var moreButton: UIButton!
    @IBOutlet private weak var ratingLabel01: UILabel!
    @IBOutlet private weak var ratingCountLabel01: UILabel!
    
    /// 평점 별(채우기 용)
    @IBOutlet private weak var ratingStarImage01: UIImageView!
    @IBOutlet private weak var ratingStarImage02: UIImageView!
    @IBOutlet private weak var ratingStarImage03: UIImageView!
    @IBOutlet private weak var ratingStarImage04: UIImageView!
    @IBOutlet private weak var ratingStarImage05: UIImageView!
    
    @IBOutlet private weak var rankLabel: UILabel!
    @IBOutlet private weak var contentsRatingLabel01: UILabel!
    
    // 02.새로운 기능
    @IBOutlet private weak var curVersionLabel: UILabel!
    @IBOutlet private weak var versionHistoryButton: UIButton!
    @IBOutlet private weak var releaseAgoLabel: UILabel!
    @IBOutlet private weak var releaseNotesTextView: UITextView!
    @IBOutlet private weak var notesMoreButton: UIButton!
    
    // 03.미리보기
    @IBOutlet private weak var screenShotsCV: UICollectionView!
    
    // 04.설명
    @IBOutlet private weak var descriptionTextView: UITextView!
    @IBOutlet private weak var descriptionMoreButton: UIButton!
    @IBOutlet private weak var sellerNameLabel: UILabel!
    @IBOutlet private weak var sellerAppsButton: UIButton!
    
    // 05. 평가 및 리뷰
    @IBOutlet private weak var reviewAllButton: UIButton!
    @IBOutlet private weak var ratingLabel02: UILabel!
    @IBOutlet private weak var ratingCountLabel02: UILabel!
    
    // 06. 평가하기
    @IBOutlet private weak var reviewCV: UICollectionView!
    @IBOutlet private weak var writeReviewButton: UIButton!
    @IBOutlet private weak var supportAppButton: UIButton!
    
    // 07.정보
    @IBOutlet private weak var artistNameLabel: UILabel!
    @IBOutlet private weak var fileSizeLabel: UILabel!
    @IBOutlet private weak var categoryLabel: UILabel!
    @IBOutlet private weak var supportedDownButton: UIButton!
    @IBOutlet private weak var supportedLabel: UILabel! {
        didSet { supportedLabel.isHidden = true }
    }
    @IBOutlet private weak var languageLabel: UILabel!
    @IBOutlet private weak var contentsRatingDownButton: UIButton!
    @IBOutlet private weak var contentsRatingLabel02: UILabel! {
        didSet { contentsRatingLabel02.isHidden = true }
    }
    @IBOutlet private weak var contentsRatingMoreButton: UIButton! {
        didSet { contentsRatingMoreButton.isHidden = true }
    }
    @IBOutlet private weak var copyrightLabel: UILabel!
    @IBOutlet private weak var developerWebButton: UIButton!
    @IBOutlet private weak var privacyPolicyButton: UIButton!
    
    
    var disposeBag: DisposeBag = .init()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    
}

extension SearchResultDetailViewController: StoryboardView {
    func bind(reactor: SearchResultDetailViewReactor) {
        
    }
}
