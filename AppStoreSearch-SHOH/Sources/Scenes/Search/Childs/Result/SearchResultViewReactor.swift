//
//  SearchResultViewReactor.swift
//  AppStoreSearch-SHOH
//
//  Created by Jayden OH on 2021/10/22.
//

import ReactorKit
import SPMSHOHProxy

typealias SearchResultSnapshotType = NSDiffableDataSourceSnapshot<Section, Section.Item>

final class SearchResultViewReactor: Reactor {
    struct Dependency: DependencyType {
        let useCase: SearchUseCase
    }
    
    enum Action {
        case updateSearchKeyword(String)
        case updateSnapshot([SearchModel.Result])
        case loadMore((String, Int))
    }
    
    enum Mutation {
        case setSearchKeyword(String)
        case setPageOffset(Int)
        case setSearchList([SearchModel.Result])
        case appendSearchList([SearchModel.Result])
        case setSnapshot(SearchResultSnapshotType)
    }
    
    struct State {
        var searchKeyword: String
        var pageOffset: Int
        var searchList: [SearchModel.Result]
        var snapshot: SearchResultSnapshotType
    }
    
    var initialState: State
    private let useCase: SearchUseCase
    
    init(_ _dependency: DependencyType) {
        let dependency = _dependency as? Dependency
        self.initialState = .init(
            searchKeyword: "",
            pageOffset: 0,
            searchList: [],
            snapshot: .init()
        )
        self.useCase = dependency?.useCase ?? .init()
    }
}

extension SearchResultViewReactor {
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case let .updateSearchKeyword(keyword):
            let pageOffset: Int = 0
            
            let setKeyword = Observable.just(Mutation.setSearchKeyword(keyword))
            let initPageOffset = Observable.just(Mutation.setPageOffset(pageOffset))
            
            let fetch = self.useCase.fetchSearchList(query: keyword, offset: pageOffset)
                .take(until: self.action.filter(Action.isUpdateSearchKeyword))
                .map(Mutation.setSearchList)
            
            return Observable.concat(setKeyword, initPageOffset, fetch)
            
        case let .loadMore((keyword, pageOffset)):
            let setPageOffset = Observable.just(Mutation.setPageOffset(pageOffset))
            
            let fetch = self.useCase.fetchSearchList(query: keyword, offset: pageOffset)
                .take(until: self.action.filter(Action.isUpdateSearchKeyword))
                .map(Mutation.appendSearchList)
            
            return Observable.concat(setPageOffset, fetch)
            
        case let .updateSnapshot(searchList):
            let setSnapshot = Observable.just(searchList)
                .observe(on: ConcurrentDispatchQueueScheduler(queue: DispatchQueue(label: "updateSnapshot")))
                .map({ list -> SearchResultSnapshotType in
                    let items = list.map({ Section.Item.result(.init($0)) })
                    
                    var snapshot: SearchResultSnapshotType = .init()
                    snapshot.appendSections([.result])
                    snapshot.appendItems(items)
                    
                    return snapshot
                })
                .observe(on: MainScheduler.asyncInstance)
                .map(Mutation.setSnapshot)
            
            return setSnapshot
        }
    }
}

extension SearchResultViewReactor {
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        switch mutation {
        case let .setSearchKeyword(keyword):
            newState.searchKeyword = keyword
            
        case let .setPageOffset(pageOffset):
            newState.pageOffset = pageOffset
            
        case let .setSearchList(searchList):
            newState.searchList = searchList
            
        case let .appendSearchList(searchList):
            newState.searchList.append(contentsOf: searchList)
            
        case let .setSnapshot(snapshot):
            newState.snapshot = snapshot
        }
        return newState
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
