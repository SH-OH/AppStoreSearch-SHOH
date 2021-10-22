//
//  SearchCoordinator.swift
//  AppStoreSearch-SHOH
//
//  Created by Jayden OH on 2021/10/22.
//

import UIKit.UINavigationController

import SPMSHOHProxy

final class SearchCoordinator: CoordinatorType {
    struct Dependency: DependencyType {
        let useCase: SearchUseCase
    }
    
    private unowned var navigationController: UINavigationController
    private var currentChild: SearchChildProtocol?
    
    init(_ navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start(with dependency: DependencyType?) {
        guard let dependency = dependency as? Dependency else {
            return
        }
        let viewController = SearchViewController.storyboard()
        viewController.title = navigationController.title
        navigationController.navigationBar.prefersLargeTitles = true
        navigationController.navigationItem.largeTitleDisplayMode = .automatic
        
        viewController.reactor = SearchViewReactor(useCase: dependency.useCase)
        viewController.coordinator = self
        navigationController.setViewControllers([viewController], animated: false)
    }
    
    func changeChild(child: SearchChildProtocol, dependecy: DependencyType) {
        if let currentChild = currentChild {
            detachChild(child: currentChild)
        }
        attachChild(child: child, dependecy: dependecy)
    }
}

extension SearchCoordinator {
    private func attachChild(child: SearchChildProtocol, dependecy: DependencyType) {
        switch child.childType {
        case .recent:
            let viewController = child.viewController(SearchRecentViewController.self)
            
            viewController.reactor = SearchRecentViewReactor(dependecy)
            viewController.view.isHidden = false
            self.currentChild = viewController
        case .result:
            let viewController = child.viewController(SearchResultViewController.self)
            viewController.reactor = SearchResultViewReactor(dependecy)
            viewController.view.isHidden = false
            self.currentChild = viewController
        }
    }
    
    private func detachChild(child: SearchChildProtocol) {
        switch child.childType {
        case .recent:
            let viewController = child.viewController(SearchRecentViewController.self)
            viewController.reactor = nil
            viewController.view.isHidden = true
        case .result:
            let viewController = child.viewController(SearchResultViewController.self)
            viewController.reactor = nil
            viewController.view.isHidden = true
        }
    }
}
