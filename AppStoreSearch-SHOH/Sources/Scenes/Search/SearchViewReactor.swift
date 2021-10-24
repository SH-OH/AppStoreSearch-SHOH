//
//  SearchViewReactor.swift
//  AppStoreSearch-SHOH
//
//  Created by Jayden OH on 2021/10/22.
//

import SPMSHOHProxy
import ReactorKit

final class SearchViewReactor: Reactor, Coordinatable {
    struct Dependency: DependencyType {
        let useCase: SearchUseCase
        let coordinator: CoordinatorType
    }
    
    enum ChildType {
        case recent
        case result
    }
    
    enum Action {
        case willChangeChild(SearchChildProtocol)
    }
    
    enum Mutation {
        
    }
    
    struct State {
        
    }
    
    let initialState: State
    let coordinator: CoordinatorType?
    private let useCase: SearchUseCase
    
    init(with dependency: DependencyType? = nil) {
        self.initialState = .init(
            
        )
        
        let dependency = dependency as? Dependency
        self.useCase = dependency?.useCase ?? .init()
        self.coordinator = dependency?.coordinator
    }
}

extension SearchViewReactor {
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case let .willChangeChild(child):
            guard let coordinator = self.coordinator else { return .empty() }
            switch child.childType {
            case .recent:
                let dependency = SearchRecentViewReactor.Dependency(
                    useCase: self.useCase,
                    child: child
                )
                coordinator.navigate(to: SearchCoordinator.Navigation.changeTochild, with: dependency)
                
            case .result:
                let dependency = SearchResultViewReactor.Dependency(
                    useCase: self.useCase,
                    coordinator: coordinator,
                    child: child
                )
                coordinator.navigate(to: SearchCoordinator.Navigation.changeTochild, with: dependency)
            }
            
            return .empty()
        }
    }
}

extension SearchViewReactor {
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        switch mutation {
        
        }
        return newState
    }
}
