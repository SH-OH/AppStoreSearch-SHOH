//
//  MainCoordinator.swift
//  AppStoreSearch-SHOH
//
//  Created by Jayden OH on 2021/10/22.
//

import UIKit.UINavigationController

import SPMSHOHProxy

final class MainCoordinator: CoordinatorType {
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
        let backgroundColor: UIColor = .white.withAlphaComponent(0.95)
        if #available(iOS 13.0, *) {
            let appearance = UINavigationBarAppearance()
            appearance.configureWithOpaqueBackground()
            appearance.backgroundColor = backgroundColor
            UINavigationBar.appearance().standardAppearance = appearance
            UINavigationBar.appearance().scrollEdgeAppearance = appearance
        } else {
            childNavigationController.navigationBar.isTranslucent = false
            childNavigationController.navigationBar.backgroundColor = backgroundColor
        }
        
        childNavigationController.title = tabBarType.title
        childNavigationController.tabBarItem = tabBarType.tabBarItem
        let childCoordinator = tabBarType.createCoordinator(childNavigationController)
        return (childNavigationController, childCoordinator)
    }
}
