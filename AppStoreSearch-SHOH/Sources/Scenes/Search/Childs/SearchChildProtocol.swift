//
//  SearchChildProtocol.swift
//  AppStoreSearch-SHOH
//
//  Created by Jayden OH on 2021/10/22.
//

import Foundation
import UIKit
import ReactorKit

protocol SearchChildProtocol where Self: UIViewController {
    var childType: SearchViewReactor.ChildType { get }
}

extension SearchChildProtocol {
    func viewController<T>(_ type: T.Type) -> T {
        guard let vc = self as? T else {
            preconditionFailure("Failed Casting SearchChildViewController : \(T.self)")
        }
        return vc
    }
    
    func createReactor<R: Reactor>() -> R? {
        switch childType {
        case .recent:
            return SearchRecentViewReactor() as? R
        case .result:
            return SearchResultViewReactor() as? R
        }
    }
}
