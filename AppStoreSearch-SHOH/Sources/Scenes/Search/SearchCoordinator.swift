//
//  SearchCoordinator.swift
//  AppStoreSearch-SHOH
//
//  Created by Jayden OH on 2021/10/22.
//

import UIKit.UINavigationController

import SPMSHOHProxy

final class SearchCoordinator: CoordinatorType {
    private unowned var navigationController: UINavigationController
    
    private let useCase: SearchUseCase
    private var children: [SearchChildProtocol]
    private var currentChild: SearchChildProtocol?
    
    
    enum Navigation: NavigationType {
        case changeTochild
        case detail
    }

    
    init(
        _ navigationController: UINavigationController,
        useCase: SearchUseCase
    ) {
        self.navigationController = navigationController
        self.useCase = useCase
        self.children = []
    }
    
    func start(with dependency: DependencyType = EmptyDependency()) {
        let dependency = SearchViewReactor.Dependency(coordinator: self)
        let viewController = SearchViewController.storyboard()
        viewController.title = navigationController.title
        navigationController.navigationBar.prefersLargeTitles = true
        navigationController.navigationItem.largeTitleDisplayMode = .automatic
        
        viewController.reactor = SearchViewReactor(
            with: dependency,
            useCase: self.useCase
        )
        navigationController.setViewControllers([viewController], animated: false)
    }
    
    func navigate(to navigation: NavigationType, with dependency: DependencyType) {
        guard let navigation = navigation as? Navigation else { return }
        switch navigation {
        case .changeTochild:
            if let currentChild = currentChild {
                detachChild(child: currentChild)
            }
            attachChild(with: dependency)
        case .detail:
            self.navigateToDetail(with: dependency)
        }
    }
    
    func setupChildren(_ children: SearchChildProtocol...) {
        self.children = children
    }
}

// MARK: - Navigation Methods

extension SearchCoordinator {
    private func navigateToDetail(with dependency: DependencyType) {
        let viewController = SearchResultDetailViewController.storyboard()
        let standard = UINavigationBarAppearance.create(
            configType: .opaque,
            backgroundColor: .white,
            hasBottomLine: false
        )
        let scroll = UINavigationBarAppearance.create(
            configType: .transparent,
            backgroundColor: .systemGray6.withAlphaComponent(0.95),
            hasBottomLine: true
        )
        
        viewController.navigationItem.standardAppearance = standard
        viewController.navigationItem.scrollEdgeAppearance = scroll
        viewController.navigationItem.largeTitleDisplayMode = .never
        
        let reactor = SearchResultDetailViewReactor(with: dependency)
        
        viewController.reactor = reactor
        
        self.navigationController.pushViewController(viewController, animated: true)
    }
    
    private func attachChild(with dependecy: DependencyType) {
        let viewController: SearchChildProtocol
        
        switch dependecy {
        case let dependecy as SearchRecentViewReactor.Dependency:
            guard let child = self.children.first(where: { $0.childType == .recent }) else {
                print("Not found recent child in children - \(children)")
                return
            }
            let _viewController = child.viewController(SearchRecentViewController.self)
            _viewController.reactor = SearchRecentViewReactor(
                with: dependecy,
                useCase: self.useCase,
                coordinator: self
            )
            viewController = _viewController
            
        case let dependecy as SearchResultViewReactor.Dependency:
            guard let child = self.children.first(where: { $0.childType == .result }) else {
                print("Not found result child in children - \(children)")
                return
            }
            let _viewController = child.viewController(SearchResultViewController.self)
            _viewController.reactor = SearchResultViewReactor(
                with: dependecy,
                useCase: self.useCase,
                coordinator: self
            )
            viewController = _viewController
            
        default:
            return
        }
        
        viewController.view.isHidden = false
        self.currentChild = viewController
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
