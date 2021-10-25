//
//  Task.swift
//  AppStoreSearch-SHOH
//
//  Created by Jayden OH on 2021/10/21.
//

import Foundation

enum Task {
    case requestPlain
    case requestParameters(parameters: [String: Any], encoding: EncodingType)
    
    enum EncodingType {
        case URLEncoding, JSONEncoding
    }
}
