//
//  SearchResultViewController.swift
//  AppStoreSearch-SHOH
//
//  Created by Jayden OH on 2021/10/22.
//

import UIKit

import SPMSHOHProxy
import ReactorKit

final class SearchResultViewController: UIViewController, StoryboardLoadable, SearchChildProtocol {
    
    @IBOutlet private weak var collectionView: UICollectionView!
    
    var disposeBag: DisposeBag = .init()
    var childType: SearchViewReactor.ChildType = .result
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.register(SearchRecentViewCell.self)
        
        collectionView.backgroundColor = .green
    }
}

extension SearchResultViewController: StoryboardView {
    func bind(reactor: SearchResultViewReactor) {
        collectionView.rx.setDelegate(self)
            .disposed(by: disposeBag)
        
        Observable.just((100...150).map(String.init))
            .bind(to: collectionView.rx.items(
                cellIdentifier: SearchRecentViewCell.reuseIdentifier,
                cellType: SearchRecentViewCell.self
            )) { index, element, cell in
                print("is result >> index : \(index) - element : \(element)")
            }.disposed(by: disposeBag)
    }
}

extension SearchResultViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        return CGSize(width: collectionView.bounds.width, height: 50)
    }
}
