//
//  TargetType.swift
//  AppStoreSearch-SHOH
//
//  Created by Jayden OH on 2021/10/21.
//

import Foundation

protocol TargetType {
    var baseURL: URL { get }
    var path: String { get }
    var method: HTTPMethod { get }
    var sampleData: Data { get }
    var task: Task { get }
    var headers: [String: String]? { get }
}
