//
//  SearchResultCell.swift
//  AppStoreSearch-SHOH
//
//  Created by Jayden OH on 2021/10/22.
//

import UIKit

import ReactorKit

final class SearchResultCell: UICollectionViewCell {
    
    @IBOutlet private weak var artworkImage: UIImageView!
    @IBOutlet private weak var trackNameLabel: UILabel!
    @IBOutlet private weak var descriptionLabel: UILabel!
    
    @IBOutlet private weak var starRatingImage01: UIImageView!
    @IBOutlet private weak var starRatingImage02: UIImageView!
    @IBOutlet private weak var starRatingImage03: UIImageView!
    @IBOutlet private weak var starRatingImage04: UIImageView!
    @IBOutlet private weak var starRatingImage05: UIImageView!
    @IBOutlet private weak var ratingCountLabel: UILabel!
    
    @IBOutlet private weak var screenShotImage01: UIImageView!
    @IBOutlet private weak var screenShotImage02: UIImageView!
    @IBOutlet private weak var screenShotImage03: UIImageView!
    
    @IBOutlet private weak var openButton: UIButton!
    
    @IBOutlet private weak var screenShotImage01Aspect: NSLayoutConstraint!
    
    @IBOutlet private weak var screenShotImage01Trailing: NSLayoutConstraint!
    @IBOutlet private weak var screenShotImage02Trailing: NSLayoutConstraint!
    @IBOutlet private weak var screenShotImage03Trailing: NSLayoutConstraint!
    
    var disposeBag: DisposeBag = .init()
    
    override func prepareForReuse() {
        super.prepareForReuse()
        artworkImage.cancel()
        screenShotImage01.cancel()
        screenShotImage02.cancel()
        screenShotImage03.cancel()
    }
    
}

extension SearchResultCell: StoryboardView {
    func bind(reactor: SearchResultCellReactor) {
        bindOutput(reactor: reactor)
        bindInput(reactor: reactor)
    }
    
    private func bindInput(reactor: SearchResultCellReactor) {
        openButton.rx.throttleTap()
            .withLatestFrom(reactor.state.map({ $0.trackId }))
            .compactMap({ URL(string: "\(Domain.AppStore.url)/id\($0)") })
            .bind(onNext: { $0.openURL() })
            .disposed(by: disposeBag)
    }
    
    private func bindOutput(reactor: SearchResultCellReactor) {
        reactor.state.map({ $0.artworkUrl })
            .distinctUntilChanged()
            .bind(to: artworkImage.rx.setImage)
            .disposed(by: disposeBag)
            
        reactor.state.map({ $0.trackName })
            .distinctUntilChanged()
            .bind(to: trackNameLabel.rx.text)
            .disposed(by: disposeBag)
        
        reactor.state.map({ $0.description })
            .distinctUntilChanged()
            .bind(to: descriptionLabel.rx.text)
            .disposed(by: disposeBag)
        
        let sharedRating = reactor.state.map({ $0.rating })
            .distinctUntilChanged()
            .share(replay: 1)
        
        sharedRating
            .compactMap({ $0[safe: 0] })
            .bind(to: starRatingImage01.rx.ratingImage)
            .disposed(by: disposeBag)
        sharedRating
            .compactMap({ $0[safe: 1] })
            .bind(to: starRatingImage02.rx.ratingImage)
            .disposed(by: disposeBag)
        sharedRating
            .compactMap({ $0[safe: 2] })
            .bind(to: starRatingImage03.rx.ratingImage)
            .disposed(by: disposeBag)
        sharedRating
            .compactMap({ $0[safe: 3] })
            .bind(to: starRatingImage04.rx.ratingImage)
            .disposed(by: disposeBag)
        sharedRating
            .compactMap({ $0[safe: 4] })
            .bind(to: starRatingImage05.rx.ratingImage)
            .disposed(by: disposeBag)
        
        reactor.state.map({ $0.userRatingCount })
            .distinctUntilChanged()
            .bind(to: ratingCountLabel.rx.text)
            .disposed(by: disposeBag)
        
        let sharedUrls = reactor.state.compactMap({ $0.screenshotUrls })
            .distinctUntilChanged()
            .share(replay: 1)
        
        reactor.state.map({ $0.screenshotType })
            .withLatestFrom(sharedUrls.map({ $0.count }), resultSelector: { ($0, $1) })
            .distinctUntilChanged({ lhs, rhs in
                let (lType, lCount) = lhs
                let (rType, rCount) = rhs
                return lType == rType && lCount == rCount
            })
            .bind(onNext: { [weak self] (type, count) in
                self?.changeScreenShotLayout(type: type, count: count)
            }).disposed(by: disposeBag)
        
        sharedUrls
            .map({ $0[safe: 0] })
            .bind(to: screenShotImage01.rx.setImage)
            .disposed(by: disposeBag)
        sharedUrls
            .map({ $0[safe: 1] })
            .bind(to: screenShotImage02.rx.setImage)
            .disposed(by: disposeBag)
        sharedUrls
            .map({ $0[safe: 2] })
            .bind(to: screenShotImage03.rx.setImage)
            .disposed(by: disposeBag)
    }
}

extension SearchResultCell {
    private func changeScreenShotLayout(
        type: ScreenshotType,
        count: Int
    ) {
        func showOne(type: ScreenshotType) {
            self.screenShotImage01Trailing.priority = .defaultHigh
            self.screenShotImage02Trailing.priority = .defaultLow
            self.screenShotImage03Trailing.priority = .defaultLow
            self.screenShotImage02.isHidden = true
            self.screenShotImage03.isHidden = true
        }
        
        defer {
            self.screenShotImage01.superview?.layoutIfNeeded()
        }
        
        self.screenShotImage01Aspect = self.screenShotImage01Aspect.changeMultiplier(type.multiplier)
        
        if type == .wide {
            showOne(type: .wide)
            return
        }
        
        switch count {
        case 1:
            showOne(type: .high)
            
        case 2:
            self.screenShotImage01Trailing.priority = .defaultLow
            self.screenShotImage02Trailing.priority = .defaultHigh
            self.screenShotImage03Trailing.priority = .defaultLow
            self.screenShotImage02.isHidden = false
            self.screenShotImage03.isHidden = true
            
        default:
            self.screenShotImage01Trailing.priority = .defaultLow
            self.screenShotImage02Trailing.priority = .defaultLow
            self.screenShotImage03Trailing.priority = .defaultHigh
            self.screenShotImage02.isHidden = false
            self.screenShotImage03.isHidden = false
        }
    }
}
