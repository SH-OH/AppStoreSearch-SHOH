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
    }
    
    enum Mutation {
        case updateChildType(ChildType)
    }
    
    struct State {
        var childType: ChildType
    }
    
    let initialState: State
    
    init() {
        self.initialState = .init(
            childType: .recent
        )
    }
}

extension SearchViewReactor {
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case let .updateChildType(childType):
            return .just(.updateChildType(childType))
        }
    }
}

extension SearchViewReactor {
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        switch mutation {
        case let .updateChildType(childType):
            newState.childType = childType
        }
        return newState
    }
}
