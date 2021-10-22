//
//  SearchViewReactor.swift
//  AppStoreSearch-SHOH
//
//  Created by Jayden OH on 2021/10/22.
//

import ReactorKit
import SPMSHOHProxy

typealias ChildInfoType = (type: SearchViewReactor.ChildType, dependency: DependencyType)

final class SearchViewReactor: Reactor {
    enum ChildType {
        case recent
        case result
    }
    
    enum Action {
        case updateChildType(ChildType)
    }
    
    enum Mutation {
        case setChildType(ChildInfoType)
    }
    
    struct State {
        var childInfo: ChildInfoType
    }
    
    let initialState: State
    private let useCase: SearchUseCase
    
    init(useCase: SearchUseCase) {
        let dependency = SearchResultViewReactor.Dependency(useCase: useCase)
        self.initialState = .init(
            childInfo: (.recent, dependency)
        )
        self.useCase = useCase
    }
}

extension SearchViewReactor {
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case let .updateChildType(childType):
            switch childType {
            case .recent:
                let dependency = SearchResultViewReactor.Dependency(useCase: self.useCase)
                return Observable.just(Mutation.setChildType((childType, dependency)))
                
            case .result:
                let dependency = SearchResultViewReactor.Dependency(useCase: self.useCase)
                return Observable.just(Mutation.setChildType((childType, dependency)))
            }
        }
    }
}

extension SearchViewReactor {
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        switch mutation {
        case let .setChildType(childInfo):
            newState.childInfo = childInfo
        }
        return newState
    }
}
