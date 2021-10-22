//
//  Number+Extensions.swift
//  AppStoreSearch-SHOH
//
//  Created by Jayden OH on 2021/10/22.
//

import Foundation

extension Int {
    var toUserCountStringValue: String {
        guard self > 0 else { return "0" }
        
        func replace(_ value: Int, max: Int) -> String {
            let prefix = String("\(value)".prefix(max))
            
            var toArray = prefix.map { $0 }
            
            if value < 1_000_000 {
                if toArray.last == "0" || toArray.last == "." {
                    while toArray.last == "0" || toArray.last == "." {
                        toArray = toArray.dropLast()
                    }
                }
                
                if toArray.count > 1 && value >= 1_000 && value < 100_000 {
                    toArray.insert(".", at: 1)
                }
            }
            
            return toArray.map { String($0) }.joined()
        }
        
        var max: Int = 3
        var currency: String = ""
        
        switch self {
        case 0..<10_000:
            max = 3
            currency = ""
            
        case 1_000..<10_000:
            max = 3
            currency = "천"
            
        case 10_000..<1_000_000:
            max = 2
            currency = "만"
            
        case 1_000_000...:
            max = 3
            currency = "만"
            
        default:
            break
        }
        
        var userRatingCount = replace(self, max: max)
        userRatingCount.append(currency)
        
        return userRatingCount
    }
    var toDecimal: String {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        return numberFormatter.string(from: self as NSNumber) ?? "0"
    }
}
