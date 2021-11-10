//
//  MainCoordinator.swift
//  AppStoreSearch-SHOH
//
//  Created by Jayden OH on 2021/10/22.
//

import UIKit.UINavigationController

import SPMSHOHProxy

final class MainCoordinator: CoordinatorType {
    
    deinit {
        print("deinit", String(describing: self))
    }
    
    private unowned var navigationController: UINavigationController
    
    init(_ navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start(with dependency: DependencyType = EmptyDependency()) {
        let mainTabBarController = UITabBarController()
        mainTabBarController.view.backgroundColor = .white
        mainTabBarController.tabBar.backgroundColor = .white.withAlphaComponent(0.95)
        
        let search = createChild(with: .search)
        
        mainTabBarController.setViewControllers(
            [search.navigationController],
            animated: false
        )
        
        navigationController.setViewControllers([mainTabBarController], animated: false)
        
        search.coordinator.start(with: EmptyDependency())
    }
    
    func navigate(to navigation: NavigationType, with dependency: DependencyType) {
        
    }
    
    private func createChild(with tabBarType: TabBarType)
    -> (navigationController: UINavigationController, coordinator: CoordinatorType)
    {
        let childNavigationController = UINavigationController()
        childNavigationController.title = tabBarType.title
        childNavigationController.tabBarItem = tabBarType.tabBarItem
        let childCoordinator = tabBarType.createCoordinator(childNavigationController)
        return (childNavigationController, childCoordinator)
    }
}
