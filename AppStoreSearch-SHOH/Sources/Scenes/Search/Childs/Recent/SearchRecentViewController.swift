//
//  SearchRecentViewController.swift
//  AppStoreSearch-SHOH
//
//  Created by Jayden OH on 2021/10/22.
//

import UIKit

import SPMSHOHProxy
import ReactorKit
import RxRelay

final class SearchRecentViewController: UIViewController, StoryboardLoadable, SearchChildProtocol {
    
    private enum Const {
        static let cellHeight: CGFloat = 50
    }
    
    @IBOutlet private weak var collectionView: UICollectionView!
    
    weak var delegate: SearchControlDelegate?
    
    var disposeBag: DisposeBag = .init()
    let childType: SearchViewReactor.ChildType = .recent
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.registerNib(SearchRecentCell.self)
    }
    
}

extension SearchRecentViewController: StoryboardView {
    func bind(reactor: SearchRecentViewReactor) {
        bindOutput(reactor: reactor)
        bindInput(reactor: reactor)
    }
    
    private func bindInput(reactor: SearchRecentViewReactor) {
        collectionView.rx.setDelegate(self)
            .disposed(by: disposeBag)
        
        collectionView.rx.itemSelected
            .withLatestFrom(
                reactor.state.map({ $0.recentList }),
                resultSelector: { $1[safe: $0.item] }
            )
            .compactMap({ $0 })
            .do(onNext: { [weak self] keyword in
                self?.delegate?.active(true, keyword: keyword)
            })
            .map(Reactor.Action.didSelectItem)
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
    }
    
    private func bindOutput(reactor: SearchRecentViewReactor) {
        reactor.state.map({ $0.recentList })
            .asDriverOnNever()
            .drive(collectionView.rx.items(cellIdentifier: SearchRecentCell.reuseIdentifier, cellType: SearchRecentCell.self))
        { index, element, cell in
            cell.configure(text: element)
        }.disposed(by: disposeBag)
    }
}

extension SearchRecentViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        return CGSize(width: collectionView.bounds.width, height: Const.cellHeight)
    }
}
