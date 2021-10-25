//
//  AppCoordinator.swift
//  AppStoreSearch-SHOH
//
//  Created by Jayden OH on 2021/10/21.
//

import UIKit

import SPMSHOHProxy

final class AppCoordinator: CoordinatorType {
    struct Dependency: DependencyType {
        let window: UIWindow?
    }
    
    func start(with dependency: DependencyType) {
        guard let dependency = dependency as? Dependency else {
            return
        }
        let rootNavigationController = UINavigationController()
        rootNavigationController.setNavigationBarHidden(true, animated: false)
        
        dependency.window?.rootViewController = rootNavigationController
        dependency.window?.makeKeyAndVisible()
        
        configureNavigationBar()
        
        let mainCoordinator = MainCoordinator(rootNavigationController)
        mainCoordinator.start()
    }
    
    func navigate(to navigation: NavigationType, with dependency: DependencyType) {}
}

extension AppCoordinator {
    private func configureNavigationBar() {
        let appearance = UINavigationBarAppearance.create(
            configType: .opaque,
            backgroundColor: .white.withAlphaComponent(0.95),
            hasBottomLine: true
        )
        UINavigationBar.appearance().standardAppearance = appearance
        UINavigationBar.appearance().scrollEdgeAppearance = appearance
    }
}
