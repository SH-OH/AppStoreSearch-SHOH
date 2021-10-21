//
//  AppCoordinator.swift
//  AppStoreSearch-SHOH
//
//  Created by Jayden OH on 2021/10/21.
//

import UIKit

import SPMSHOHProxy

final class AppCoordinator: CoordinatorType {
    struct AppDependency: Dependency {
        let window: UIWindow?
    }
    
    func start(with dependency: Dependency? = nil) {
        guard let dependency = dependency as? AppDependency else {
            return
        }
        let rootNavigationController = UINavigationController()
        rootNavigationController.setNavigationBarHidden(true, animated: false)
        dependency.window?.rootViewController = rootNavigationController
        dependency.window?.makeKeyAndVisible()
        
        let mainCoordinator = MainCoordinator(rootNavigationController)
        coordinate(to: mainCoordinator)
    }
    
}
