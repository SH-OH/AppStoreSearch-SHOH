//
//  Section.swift
//  AppStoreSearch-SHOH
//
//  Created by Jayden OH on 2021/10/23.
//

import Foundation

enum Section {
    case result
    
    enum Item: Hashable {
        case result(SearchResultCellReactor.Dependency)
    }
}
