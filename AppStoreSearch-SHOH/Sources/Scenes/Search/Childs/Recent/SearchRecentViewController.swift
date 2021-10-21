//
//  SearchRecentViewController.swift
//  AppStoreSearch-SHOH
//
//  Created by Jayden OH on 2021/10/22.
//

import UIKit

import SPMSHOHProxy
import ReactorKit

final class SearchRecentViewController: UIViewController, StoryboardLoadable, SearchChildProtocol {
    
    @IBOutlet private weak var collectionView: UICollectionView!
    
    var disposeBag: DisposeBag = .init()
    var childType: SearchViewReactor.ChildType = .recent
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.register(SearchRecentViewCell.self)
        
        collectionView.backgroundColor = .cyan
    }
}

extension SearchRecentViewController: StoryboardView {
    func bind(reactor: SearchRecentViewReactor) {
        collectionView.rx.setDelegate(self)
            .disposed(by: disposeBag)
        
        Observable.just((10...40).map(String.init))
            .bind(to: collectionView.rx.items(
                cellIdentifier: SearchRecentViewCell.reuseIdentifier,
                cellType: SearchRecentViewCell.self
            )) { index, element, cell in
                print("is recent >> index : \(index) - element : \(element)")
            }.disposed(by: disposeBag)
    }
}

extension SearchRecentViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        return CGSize(width: collectionView.bounds.width, height: 50)
    }
}
