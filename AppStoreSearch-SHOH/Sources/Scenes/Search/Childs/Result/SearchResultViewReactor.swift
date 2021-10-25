//
//  SearchResultViewReactor.swift
//  AppStoreSearch-SHOH
//
//  Created by Jayden OH on 2021/10/22.
//

import Foundation

import ReactorKit
import SPMSHOHProxy

typealias SearchResultSnapshotType = NSDiffableDataSourceSnapshot<Section, Section.Item>

final class SearchResultViewReactor: Reactor, Coordinatable {
    struct Dependency: DependencyType {
        let useCase: SearchUseCase
        let coordinator: CoordinatorType
        let child: SearchChildProtocol
    }
    
    private enum Const {
        static let displayCount: Int = 50
        static let defaultPageNumber: Int = 1
    }
    
    enum Action {
        case updateSearchKeyword(String)
        case updateDisplaySearchList((Int, [SearchModel.Result]))
        case updateSnapshot([SearchModel.Result])
        case loadMore(Int)
        case didSelectItem((IndexPath, [SearchModel.Result]))
    }
    
    enum Mutation {
        case setSearchKeyword(String)
        case setPageNumber(Int)
        case setIsEnableLoadMore(Bool)
        case setSearchList([SearchModel.Result])
        case setDisplaySearchList([SearchModel.Result])
        case appendDisplaySearchList([SearchModel.Result])
        case setSnapshot(SearchResultSnapshotType)
    }
    
    struct State {
        var searchKeyword: String
        var pageNumber: Int?
        var isEnableLoadMore: Bool
        var searchList: [SearchModel.Result]
        var displaySearchList: [SearchModel.Result]
        var snapshot: SearchResultSnapshotType
    }
    
    var initialState: State
    let coordinator: CoordinatorType?
    private let useCase: SearchUseCase
    
    init(with dependency: DependencyType) {
        let dependency = dependency.cast(Dependency.self)
        self.initialState = .init(
            searchKeyword: "",
            pageNumber: nil,
            isEnableLoadMore: false,
            searchList: [],
            displaySearchList: [],
            snapshot: .init()
        )
        self.useCase = dependency.useCase
        self.coordinator = dependency.coordinator
    }
}

extension SearchResultViewReactor {
    func transform(action: Observable<Action>) -> Observable<Action> {
        return action
            .flatMap({ _action -> Observable<Action> in
                switch _action {
                case .didSelectItem:
                    return .just(_action)
                default:
                    return .just(_action)
                        .subscribe(on: SerialDispatchQueueScheduler(qos: .default))
                        .observe(on: MainScheduler.asyncInstance)
                }
            })
    }
}

extension SearchResultViewReactor {
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case let .updateSearchKeyword(keyword):
            let setPageNumber = Observable.just(Mutation.setPageNumber(Const.defaultPageNumber))
            
            let fetchList = self.fetchSearchList(query: keyword)
                .share()
            
            let setIsEnableLoadMore = fetchList
                .map({ $0.count > Const.displayCount })
                .map(Mutation.setIsEnableLoadMore)
            
            let setSearchList = fetchList
                .map(Mutation.setSearchList)
            
            return Observable.concat(setSearchList, setPageNumber, setIsEnableLoadMore)
            
        case let .updateDisplaySearchList((pageNumber, searchList)):
            
            let count = Const.displayCount * pageNumber
            let newDisplayList = Array(searchList.prefix(count))
            
            let isLastPage: Bool = newDisplayList.count >= searchList.count
            
            let setIsLastPage = Observable.just(isLastPage)
                .map({ !$0 })
                .map(Mutation.setIsEnableLoadMore)
            
            let setDisplayList = Observable.just(newDisplayList)
                .map(Mutation.setDisplaySearchList)
            
            return Observable.concat(setIsLastPage, setDisplayList)
            
        case let .loadMore(pageNumber):
            let pageNumber: Int = pageNumber + 1
            let setpageNumber = Observable.just(Mutation.setPageNumber(pageNumber))
            
            return Observable.concat(setpageNumber)
            
        case let .updateSnapshot(searchList):
            let setSnapshot = Observable.just(searchList)
                .map({ list -> SearchResultSnapshotType in
                    let items = list.map({ Section.Item.result(.init($0)) })
                    
                    var snapshot: SearchResultSnapshotType = .init()
                    snapshot.appendSections([.result])
                    snapshot.appendItems(items)
                    
                    return snapshot
                })
                .map(Mutation.setSnapshot)
            
            return setSnapshot
            
        case let .didSelectItem((indexPath, searchList)):
            guard let coordinator = self.coordinator else { return .empty() }
            guard let selectedItem = searchList[safe: indexPath.item] else {
                return .empty()
            }
            let dependency = SearchResultDetailViewReactor.Dependency(
                useCase: self.useCase,
                coordinator: coordinator,
                item: selectedItem
            )
            coordinator.navigate(
                to: SearchCoordinator.Navigation.detail,
                with: dependency
            )
            return .empty()
        }
    }
}

extension SearchResultViewReactor {
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        switch mutation {
        case let .setSearchKeyword(newValue):
            newState.searchKeyword = newValue
            
        case let .setPageNumber(newValue):
            newState.pageNumber = newValue
            
        case let .setIsEnableLoadMore(newValue):
            newState.isEnableLoadMore = newValue
            
        case let .setSearchList(newValue):
            newState.searchList = newValue
            
        case let .setDisplaySearchList(newValue):
            newState.displaySearchList = newValue
            
        case let .appendDisplaySearchList(newValue):
            newState.displaySearchList.append(contentsOf: newValue)
            
        case let .setSnapshot(newValue):
            newState.snapshot = newValue
        }
        return newState
    }
}

extension SearchResultViewReactor {
    private func fetchSearchList(query: String) -> Observable<[SearchModel.Result]> {
        return self.useCase.fetchSearchList(query: query)
            .take(until: self.action.filter(Action.isUpdateSearchKeyword))
            .catch({ error -> Observable<[SearchModel.Result]> in
                print("Failed fetchSearchList : \(error)")
                return .empty()
            })
    }
}

private extension SearchResultViewReactor.Action {
    static func isUpdateSearchKeyword(_ action: SearchResultViewReactor.Action) -> Bool {
        if case .updateSearchKeyword = action {
            return true
        } else {
            return false
        }
    }
}
