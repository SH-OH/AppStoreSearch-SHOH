//
//  SearchResultDetailViewReactor.swift
//  AppStoreSearch-SHOH
//
//  Created by Jayden OH on 2021/10/23.
//

import Foundation

import SPMSHOHProxy
import ReactorKit

final class SearchResultDetailViewReactor: Reactor, Coordinatable {
    struct Dependency: DependencyType {
        let useCase: SearchUseCase
        let coordinator: CoordinatorType
        let item: SearchModel.Result
    }
    
    enum Action {
        
    }
    
    enum Mutation {
        
    }
    
    struct State {
        var artworkUrl100: String
        var trackName: String
        var ratingDouble: Double
        var ratingArray: [Double]
        var userRatingCount: Int
        var artistName: String
        var fileSizeBytes: String
        var genreName: String
        var contentRating: String
        var version: String
        var updateDate: Date
        var releaseNotes: String
        var description: String
        var sellerName: String
        var isSupported: String
        var supported: String
        var languageList: [String]
        var languages: String
        var trackViewUrl: String
        var sellerUrl: String
        var artistViewUrl: String
        var writeReviewUrl: String
    }
    
    let initialState: State
    private let useCase: SearchUseCase
    let coordinator: CoordinatorType?
    
    init(with dependency: DependencyType) {
        self.initialState = .init(
            artworkUrl100: "",
            trackName: "",
            ratingDouble: 0,
            ratingArray: [],
            userRatingCount: 0,
            artistName: "",
            fileSizeBytes: "",
            genreName: "",
            contentRating: "",
            version: "",
            updateDate: .now,
            releaseNotes: "",
            description: "",
            sellerName: "",
            isSupported: "",
            supported: "",
            languageList: [],
            languages: "",
            trackViewUrl: "",
            sellerUrl: "",
            artistViewUrl: "",
            writeReviewUrl: ""
        )
        let dependency = dependency as? Dependency
        self.useCase = dependency?.useCase ?? .init()
        self.coordinator = dependency?.coordinator
    }
}
