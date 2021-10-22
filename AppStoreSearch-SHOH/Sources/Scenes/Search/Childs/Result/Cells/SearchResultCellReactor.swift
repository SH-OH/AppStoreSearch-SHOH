//
//  SearchResultCellReactor.swift
//  AppStoreSearch-SHOH
//
//  Created by Jayden OH on 2021/10/22.
//

import Foundation
import ReactorKit
import UIKit

final class SearchResultCellReactor: Reactor {
    struct Item {
        let uuid: UUID
        let artworkUrl60: String
        let trackName: String
        let description: String
        let ratingArray: [Double]
        let userRatingCount: String
        let screenshotType: SearchModel.Result.ScreenshotType
        let screenshotUrls: [String]
        
        private static var numberFormatter: NumberFormatter {
            let numberFormatter = NumberFormatter()
            numberFormatter.numberStyle = .decimal
            numberFormatter.minimumFractionDigits = 2
            numberFormatter.maximumFractionDigits = 2
            return numberFormatter
        }
        
        init(_ result: SearchModel.Result) {
            let averUserRating = Self.numberFormatter.string(from: result.averageUserRatingForCurrentVersion as NSNumber) ?? "0"
            let ratingToDouble = Double(averUserRating) ?? 0
            
            var ratingArray: [Double] = []
            for index in 0..<5 {
                var rating = ratingToDouble-Double(index)
                switch rating {
                case ...0:
                    rating = 0
                case 1...:
                    rating = 1
                default:
                    break
                }
                ratingArray.append(rating)
            }
            
            self.uuid = UUID()
            self.artworkUrl60 = result.artworkUrl60
            self.trackName = result.trackName
            self.description = result.description
            self.ratingArray = ratingArray
            self.userRatingCount = result.userRatingCountForCurrentVersion.toUserCountStringValue
            self.screenshotType = result.screenshotType
            self.screenshotUrls = result.screenshotUrls
        }
    }
    
    enum Action {
        case open
    }
    
    enum Mutation {
        
    }
    
    struct State {
        var artworkUrl: String
        var trackName: String
        var description: String
        var rating: [Double]
        var userRatingCount: String
        var screenshotType: SearchModel.Result.ScreenshotType
        var screenshotUrls: [String]
    }
    
    let initialState: State
    
    init(item: Item) {
        self.initialState = .init(
            artworkUrl: item.artworkUrl60,
            trackName: item.trackName,
            description: item.description,
            rating: item.ratingArray,
            userRatingCount: item.userRatingCount,
            screenshotType: item.screenshotType,
            screenshotUrls: item.screenshotUrls
        )
    }
    
}

extension SearchResultCellReactor.Item: Hashable {
    func hash(into hasher: inout Hasher) {
        hasher.combine(uuid)
    }
    
    static func == (lhs: SearchResultCellReactor.Item, rhs: SearchResultCellReactor.Item) -> Bool {
        return lhs.uuid == rhs.uuid
    }
}
