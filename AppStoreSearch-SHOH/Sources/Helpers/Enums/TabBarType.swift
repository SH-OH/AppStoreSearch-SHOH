//
//  TabBarType.swift
//  AppStoreSearch-SHOH
//
//  Created by Jayden OH on 2021/10/22.
//

import UIKit

import SPMSHOHProxy

enum TabBarType: Int {
    case search
    
    var title: String {
        switch self {
        case .search:
            return "검색"
        }
    }
    
    var tabBarItem: UITabBarItem {
        switch self {
        case .search:
            return UITabBarItem(tabBarSystemItem: .search, tag: self.rawValue)
        }
    }
    
    func createCoordinator(_ navigationController: UINavigationController) -> CoordinatorType {
        switch self {
        case .search:
            return SearchCoordinator(navigationController, useCase: SearchUseCase())
        }
    }
}
