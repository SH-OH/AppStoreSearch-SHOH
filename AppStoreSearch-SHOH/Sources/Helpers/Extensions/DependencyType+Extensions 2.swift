//
//  DependencyType+Extensions.swift
//  AppStoreSearch-SHOH
//
//  Created by Jayden OH on 2021/10/25.
//

import Foundation

import SPMSHOHProxy

extension DependencyType {
    func isEqual<T>(_ target: T) -> Bool {
        return "\(self)" == "\(target.self)"
    }
}
