//
//  SearchResultCellReactor.swift
//  AppStoreSearch-SHOH
//
//  Created by Jayden OH on 2021/10/22.
//

import Foundation

import SPMSHOHProxy
import ReactorKit

final class SearchResultCellReactor: Reactor {
    struct Dependency: DependencyType {
        let uuid: String
        let trackId: Int
        let artworkUrl60: String
        let trackName: String
        let description: String
        let ratingArray: [Double]
        let userRatingCount: String
        let screenshotType: ScreenshotType
        let screenshotUrls: [String]
        
        init(_ result: SearchModel.Result) {
            self.uuid = UUID().uuidString
            self.trackId = result.trackId
            self.artworkUrl60 = result.artworkUrl60
            self.trackName = result.trackName
            self.description = result.description
            self.ratingArray = result.ratingArray
            self.userRatingCount = result.userRatingCountForCurrentVersion.toUserCountStringValue
            self.screenshotType = result.screenshotType
            self.screenshotUrls = result.screenshotUrls
        }
    }
    
    enum Action {
        
    }
    
    enum Mutation {
        
    }
    
    struct State {
        var artworkUrl: String
        var trackId: Int
        var trackName: String
        var description: String
        var rating: [Double]
        var userRatingCount: String
        var screenshotType: ScreenshotType
        var screenshotUrls: [String]
    }
    
    let initialState: State
    
    init(with dependency: DependencyType) {
        let dependency = dependency.cast(Dependency.self)
        
        let artworkUrl = dependency.artworkUrl60
        let trackId = dependency.trackId
        let trackName = dependency.trackName
        let description = dependency.description
        let rating = dependency.ratingArray
        let userRatingCount = dependency.userRatingCount
        let screenshotType = dependency.screenshotType
        let screenshotUrls = dependency.screenshotUrls
        
        self.initialState = .init(
            artworkUrl: artworkUrl,
            trackId: trackId,
            trackName: trackName,
            description: description,
            rating: rating,
            userRatingCount: userRatingCount,
            screenshotType: screenshotType,
            screenshotUrls: screenshotUrls
        )
    }
    
}

extension SearchResultCellReactor.Dependency: Hashable {
    func hash(into hasher: inout Hasher) {
        hasher.combine(uuid)
    }
    
    static func == (lhs: SearchResultCellReactor.Dependency, rhs: SearchResultCellReactor.Dependency) -> Bool {
        return lhs.uuid == rhs.uuid
    }
}
