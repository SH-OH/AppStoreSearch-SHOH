//
//  SearchRecentViewReactor.swift
//  AppStoreSearch-SHOH
//
//  Created by Jayden OH on 2021/10/22.
//

import ReactorKit
import SPMSHOHProxy

final class SearchRecentViewReactor: Reactor {
    struct Dependency: DependencyType {
        let useCase: SearchUseCase
        let child: SearchChildProtocol
    }
    
    enum Action {
        
    }
    
    enum Mutation {
        
    }
    struct State {
        
    }
    
    let initialState: State
    private let useCase: SearchUseCase
    
    init(with dependency: DependencyType) {
        let dependency = dependency.cast(Dependency.self)
        self.initialState = .init()
        self.useCase = dependency.useCase
    }
}
