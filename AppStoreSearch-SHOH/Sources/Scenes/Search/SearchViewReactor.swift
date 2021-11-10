//
//  SearchViewReactor.swift
//  AppStoreSearch-SHOH
//
//  Created by Jayden OH on 2021/10/22.
//

import SPMSHOHProxy
import ReactorKit

final class SearchViewReactor: Reactor, Coordinatable {
    
    deinit {
        print("deinit", String(describing: self))
    }
    
    struct Dependency: DependencyType {
        let coordinator: CoordinatorType
    }
    
    enum ChildType {
        case recent
        case result
    }
    
    enum Action {
        case willChangeChild(DependencyType)
    }
    
    enum Mutation {
        case setRecentList([String])
    }
    
    struct State {
        var recentList: [String]
    }
    
    let initialState: State
    let coordinator: CoordinatorType?
    private let useCase: SearchUseCaseType
    
    init(with dependency: DependencyType, useCase: SearchUseCaseType) {
        let dependency = dependency.cast(Dependency.self)
        self.initialState = .init(
            recentList: UserDefaultsStorage.recentSearchKeywords
        )
        
        self.useCase = useCase
        self.coordinator = dependency.coordinator
    }
    
    func transform(mutation: Observable<Mutation>) -> Observable<Mutation> {
        let setObservedRecentList = UserDefaults.standard.rx.observe([String].self, UserDefaultsStorage.Key.RecentSearchKeywords.rawValue)
            .compactMap({ $0 })
            .map(Mutation.setRecentList)
        
        return Observable.merge(mutation, setObservedRecentList)
    }
}

extension SearchViewReactor {
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case let .willChangeChild(dependency):
            coordinator?.navigate(to: SearchCoordinator.Navigation.changeTochild, with: dependency)
            return .empty()
        }
    }
}

extension SearchViewReactor {
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        switch mutation {
        case let .setRecentList(newValue):
            newState.recentList = newValue
        }
        return newState
    }
}
