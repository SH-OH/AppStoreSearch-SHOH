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
    }
    
    enum Action {
        
    }
    
    enum Mutation {
        
    }
    struct State {
        
    }
    
    let initialState: State
    private let useCase: SearchUseCase
    
    init(_ _dependency: DependencyType) {
        let dependency = _dependency as? Dependency
        self.initialState = .init()
        self.useCase = dependency?.useCase ?? .init()
    }
}
