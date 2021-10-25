//
//  SearchRecentViewReactor.swift
//  AppStoreSearch-SHOH
//
//  Created by Jayden OH on 2021/10/22.
//

import ReactorKit
import SPMSHOHProxy

final class SearchRecentViewReactor: Reactor, Coordinatable {
    struct Dependency: DependencyType {
        let recentList: [String]
    }
    
    enum Action {
        case didSelectItem(String)
    }
    
    enum Mutation {
        
    }
    
    struct State {
        var recentList: [String]
    }
    
    let initialState: State
    let coordinator: CoordinatorType?
    private let useCase: SearchUseCase
    
    init(
        with dependency: DependencyType,
        useCase: SearchUseCase,
        coordinator: CoordinatorType
    ) {
        let dependency = dependency.cast(Dependency.self)
        self.initialState = .init(
            recentList: dependency.recentList
        )
        self.useCase = useCase
        self.coordinator = coordinator
    }
}

extension SearchRecentViewReactor {
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case let .didSelectItem(recentKeyword):
            let dependency = SearchResultViewReactor.Dependency(searchKeyword: recentKeyword)
            coordinator?.navigate(to: SearchCoordinator.Navigation.changeTochild, with: dependency)
            return .empty()
        }
    }
}
