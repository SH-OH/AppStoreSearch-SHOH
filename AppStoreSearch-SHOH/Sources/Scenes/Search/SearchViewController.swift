//
//  SearchViewController.swift
//  AppStoreSearch-SHOH
//
//  Created by Jayden OH on 2021/10/22.
//

import UIKit

import SPMSHOHProxy
import ReactorKit
import RxSwift
import RxCocoa
import SnapKit

final class SearchViewController: UIViewController, StoryboardLoadable {
    
    private enum Const {
        static let placeholder: String = "게임, 앱, 스토리 등"
        static let cancelTitleKeyValue: (key: String, value: String) = ("cancelButtonText", "취소")
    }
    
    var disposeBag: DisposeBag = .init()
    var coordinator: SearchCoordinator?
    
    private let searchController: UISearchController = {
        let searchController = UISearchController(searchResultsController: nil)
        searchController.searchBar.placeholder = Const.placeholder
        searchController.searchBar.setValue(Const.cancelTitleKeyValue.value, forKey: Const.cancelTitleKeyValue.key)
        return searchController
    }()
    
    private let recentViewController: SearchRecentViewController = {
        let viewController = SearchRecentViewController.storyboard()
        return viewController
    }()
    private let resultViewController: SearchResultViewController = {
        let viewController = SearchResultViewController.storyboard()
        viewController.view.isHidden = true
        return viewController
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        setupChildren()
    }
    
    private func setupNavigationBar() {
        self.navigationItem.searchController = searchController
    }
    
    private func setupChildren() {
        addChild(recentViewController)
        addChild(resultViewController)
        view.addSubview(recentViewController.view)
        view.addSubview(resultViewController.view)
        recentViewController.view.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        resultViewController.view.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        recentViewController.didMove(toParent: self)
        resultViewController.didMove(toParent: self)
    }
}

extension SearchViewController: StoryboardView {
    func bind(reactor: SearchViewReactor) {
        bindOutput(reactor: reactor)
        bindInput(reactor: reactor)
    }
    
    private func bindInput(reactor: SearchViewReactor) {
        let searchBar = searchController.searchBar
        let sharedSearchClicked = searchBar.rx.searchButtonClicked
            .share()
        
        let sharedText = searchBar.rx.text.orEmpty
            .distinctUntilChanged()
            .share()
        
        sharedSearchClicked
            .withLatestFrom(sharedText)
            .bind(to: resultViewController.searchClickedEvent)
            .disposed(by: disposeBag)
        
        Observable<SearchViewReactor.ChildType>.merge(
            sharedSearchClicked.map({ .result }),
            searchBar.rx.cancelButtonClicked.map({ .recent }),
            sharedText.map({ _ in .recent })
        )
            .distinctUntilChanged()
            .map(Reactor.Action.updateChildType)
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
    }
    
    private func bindOutput(reactor: SearchViewReactor) {
        reactor.state.map({ $0.childInfo })
            .bind(onNext: { [weak self] childInfo in
                guard let self = self else { return }
                switch childInfo.type {
                case .recent:
                    self.coordinator?.changeChild(child: self.recentViewController, dependecy: childInfo.dependency)
                    
                case .result:
                    self.coordinator?.changeChild(child: self.resultViewController, dependecy: childInfo.dependency)
                }
            }).disposed(by: disposeBag)
    }
}
