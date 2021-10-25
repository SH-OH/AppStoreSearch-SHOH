//
//  Reactive+Extensions.swift
//  AppStoreSearch-SHOH
//
//  Created by Jayden OH on 2021/10/22.
//

import Foundation

import RxSwift
import RxCocoa
import RxGesture

extension Reactive where Base: UIImageView {
    var setImage: Binder<String?> {
        return Binder(base) { imageView, url in
            imageView.setImage(with: url)
        }
    }
    
    var ratingImage: Binder<Double?> {
        return Binder(base) { imageView, rating in
            imageView.setRatingImage(CGFloat(rating ?? 0))
        }
    }
}

extension Reactive where Base: UICollectionView {
    func reachedBottom(offset: CGFloat = 0.0) -> ControlEvent<Void> {
        let source = contentOffset.map { contentOffset in
            let visibleHeight = self.base.frame.height
                - self.base.contentInset.top
                - self.base.contentInset.bottom
            let y = contentOffset.y + self.base.contentInset.top
            let threshold = max(offset, self.base.contentSize.height - visibleHeight)
            return y >= threshold
        }
        .distinctUntilChanged()
        .filter { $0 }
        .map { _ in () }
        return ControlEvent(events: source)
    }
}

extension Reactive where Base: UIButton {
    func throttleTap(_ dueTime: RxTimeInterval = .milliseconds(400)) -> ControlEvent<Void> {
        let source = base.rx.tap
            .throttle(dueTime, latest: false, scheduler: MainScheduler.instance)
        
        return ControlEvent(events: source)
    }
}

extension Reactive where Base: UIView {
    func throttleTapGesture(_ dueTime: RxTimeInterval = .milliseconds(400)) -> Observable<UITapGestureRecognizer> {
        return base.rx.tapGesture()
            .when(.recognized)
            .throttle(dueTime, latest: false, scheduler: MainScheduler.init())
    }
}

extension Reactive where Base: UISearchBar {
    var textDidChange: ControlProperty<String?> {
        let source = base.rx.delegate
            .methodInvoked(#selector(UISearchBarDelegate.searchBar(_:textDidChange:)))
            .map({ $0[safe: 1] as? String })
        
        let bindingObserver = Binder(base) { searchBar, text in
            searchBar.text = text
        }
        
        return ControlProperty(values: source, valueSink: bindingObserver)
    }
}
