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

protocol SearchControlDelegate: AnyObject {
    func active(_ isActive: Bool, keyword: String?)
}

final class SearchViewController: UIViewController, StoryboardLoadable {
    
    private enum Const {
        static let placeholder: String = "게임, 앱, 스토리 등"
        static let cancelTitleKeyValue: (key: String, value: String) = ("cancelButtonText", "취소")
    }
    
    var disposeBag: DisposeBag = .init()
    
    private let searchController: UISearchController = {
        let searchController = UISearchController(searchResultsController: nil)
        searchController.searchBar.placeholder = Const.placeholder
        searchController.searchBar.setValue(Const.cancelTitleKeyValue.value, forKey: Const.cancelTitleKeyValue.key)
        searchController.searchBar.autocorrectionType = .no
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
        configureNavigationBar()
        configureDelegate()
        configureChildren()
    }
    
    private func configureNavigationBar() {
        self.navigationItem.searchController = searchController
    }
    
    private func configureChildren() {
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
        (reactor?.coordinator as? SearchCoordinator)?.setupChildren(recentViewController, resultViewController)
    }
    
    private func configureDelegate() {
        recentViewController.delegate = self
    }
}

extension SearchViewController: StoryboardView {
    func bind(reactor: SearchViewReactor) {
        bindOutput(reactor: reactor)
        bindInput(reactor: reactor)
    }
    
    private func bindInput(reactor: SearchViewReactor) {
        let searchBar = searchController.searchBar
        
        let sharedText = searchBar.rx.textDidChange
            .compactMap({ $0 })
            .share()
        
        let resultWithDependency = searchBar.rx.searchButtonClicked
            .withLatestFrom(sharedText)
            .compactMap({ searchKeyword -> DependencyType? in
                return SearchResultViewReactor.Dependency(searchKeyword: searchKeyword)
            })
            
        let defaultRecentWithDependency = Observable.merge(
            rx.sentMessage(#selector(UIViewController.viewWillAppear(_:))).mapToVoid().take(1),
            searchBar.rx.cancelButtonClicked.asObservable()
        )
            .withLatestFrom(reactor.state.map({ $0.recentList }))
            .compactMap({ recentList -> DependencyType? in
                return SearchRecentViewReactor.Dependency(recentList: recentList)
            })
        
        let searchingRecentWithDependency = sharedText
            .withLatestFrom(
                reactor.state.map({ $0.recentList }),
                resultSelector: { ($0, $1) }
            )
            .compactMap({ keyword, recentList -> DependencyType? in
                let filteredList = recentList.lazy.filter({ $0.contains(keyword) })
                return SearchRecentViewReactor.Dependency(recentList: Array(filteredList))
            })
            
        Observable<DependencyType>.merge(
            defaultRecentWithDependency,
            searchingRecentWithDependency,
            resultWithDependency
        )
            .map(Reactor.Action.willChangeChild)
            .asDriverOnNever()
            .drive(reactor.action)
            .disposed(by: disposeBag)
    }
    
    private func bindOutput(reactor: SearchViewReactor) {
        
    }
}

extension SearchViewController: SearchControlDelegate {
    func active(_ isActive: Bool, keyword: String?) {
        self.searchController.searchBar.rx.text.onNext(keyword)
        self.searchController.isActive = isActive
        self.searchController.searchBar.endEditing(true)
    }
}
