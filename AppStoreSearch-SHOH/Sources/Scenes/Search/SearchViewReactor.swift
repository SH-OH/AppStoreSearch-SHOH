//
//  SearchViewReactor.swift
//  AppStoreSearch-SHOH
//
//  Created by Jayden OH on 2021/10/22.
//

import ReactorKit

final class SearchViewReactor: Reactor {
    enum ChildType {
        case recent, result
    }
    
    enum Action {
        case updateChildType(ChildType)
        case updateSearchKeyword(String)
    }
    
    enum Mutation {
        case setChildType(ChildType)
        case setSearchKeyword(String)
        case setSearchList([SearchModel.Result])
    }
    
    struct State {
        var childType: ChildType
        var searchKeyword: String
        var searchList: [SearchModel.Result]
    }
    
    let initialState: State
    private let useCase: SearchUseCase
    
    init(useCase: SearchUseCase) {
        self.initialState = .init(
            childType: .recent,
            searchKeyword: "",
            searchList: []
        )
        self.useCase = useCase
    }
}

extension SearchViewReactor {
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case let .updateChildType(childType):
            return .just(.setChildType(childType))
            
        case let .updateSearchKeyword(keyword):
            let setKeyword = Observable.just(Mutation.setSearchKeyword(keyword))
            
            let fetch = self.useCase.fetchSearchList(query: keyword)
//                .take(until: self.action.filter(Action.isUpdateSearchKeyword))
                .map(Mutation.setSearchList)
            
            return Observable.concat(setKeyword, fetch)
        }
    }
}

extension SearchViewReactor {
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        switch mutation {
        case let .setChildType(childType):
            newState.childType = childType
            
        case let .setSearchKeyword(keyword):
            newState.searchKeyword = keyword
            
        case let .setSearchList(searchList):
            newState.searchList = searchList
        }
        return newState
    }
}

private extension SearchViewReactor.Action {
    static func isUpdateSearchKeyword(_ action: SearchViewReactor.Action) -> Bool {
        if case .updateSearchKeyword = action {
            return true
        } else {
            return false
        }
    }
}
