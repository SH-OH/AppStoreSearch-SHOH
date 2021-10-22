//
//  SearchResultViewController.swift
//  AppStoreSearch-SHOH
//
//  Created by Jayden OH on 2021/10/22.
//

import UIKit

import SPMSHOHProxy
import ReactorKit
import RxSwift
import RxRelay

final class SearchResultViewController: UIViewController, StoryboardLoadable, SearchChildProtocol {
    
    private enum Const {
        static let cellHeight: CGFloat = 270
    }
    
    @IBOutlet private weak var collectionView: UICollectionView!
    
    var disposeBag: DisposeBag = .init()
    var childType: SearchViewReactor.ChildType = .result
    
    let searchClickedEvent: BehaviorRelay<String> = .init(value: "")
    
    private lazy var dataSource: UICollectionViewDiffableDataSource<Section, Section.Item> = {
        return UICollectionViewDiffableDataSource<Section, Section.Item>(collectionView: collectionView) { collectionView, indexPath, itemIdentifier in
            switch itemIdentifier {
            case let .result(item):
                let cell = collectionView.dequeue(SearchResultCell.self, for: indexPath)
                cell.reactor = SearchResultCellReactor(item: item)
                return cell
            }
        }
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.registerNib(SearchResultCell.self)
    }
}

extension SearchResultViewController: StoryboardView {
    func bind(reactor: SearchResultViewReactor) {
        bindOut(reactor: reactor)
        bindInput(reactor: reactor)
    }
    
    private func bindInput(reactor: SearchResultViewReactor) {
        collectionView.rx.setDelegate(self)
            .disposed(by: disposeBag)
        
        searchClickedEvent
            .map(Reactor.Action.updateSearchKeyword)
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        collectionView.rx.reachedBottom()
            .withLatestFrom(reactor.state.map({ ($0.searchKeyword, $0.pageOffset+1) }))
            .filter({ !$0.0.isEmpty })
            .map(Reactor.Action.loadMore)
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
    }
    
    private func bindOut(reactor: SearchResultViewReactor) {
        reactor.state.map({ $0.searchList })
            .distinctUntilChanged()
            .map(Reactor.Action.updateSnapshot)
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        reactor.state.map({ $0.snapshot })
            .asDriverOnNever()
            .drive(onNext: { [weak dataSource] snapshot in
                dataSource?.apply(snapshot, animatingDifferences: true)
            }).disposed(by: disposeBag)
    }
    
}

extension SearchResultViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        return CGSize(width: collectionView.bounds.width, height: Const.cellHeight)
    }
}
