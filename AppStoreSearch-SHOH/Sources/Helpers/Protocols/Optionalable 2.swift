//
//  Optionalable.swift
//  AppStoreSearch-SHOH
//
//  Created by Jayden OH on 2021/10/25.
//

import Foundation

protocol Optionalable {
    var isNil: Bool { get }
}

extension Optional: Optionalable {
    var isNil: Bool {
        return self == nil
    }
}
