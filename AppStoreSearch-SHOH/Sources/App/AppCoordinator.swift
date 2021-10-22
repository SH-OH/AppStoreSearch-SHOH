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
    
    func start(with dependency: DependencyType? = nil) {
        guard let dependency = dependency as? Dependency else {
            return
        }
        let rootNavigationController = UINavigationController()
        rootNavigationController.setNavigationBarHidden(true, animated: false)
        dependency.window?.rootViewController = rootNavigationController
        dependency.window?.makeKeyAndVisible()
        
        let mainCoordinator = MainCoordinator(rootNavigationController)
        coordinate(to: mainCoordinator, with: nil)
    }
    
}
