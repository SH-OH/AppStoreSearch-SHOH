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
        var updateDate: String
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
        let dependency = dependency.cast(Dependency.self)
        
        let artworkUrl100: String = dependency.item.artworkUrl100
        let trackName: String = dependency.item.trackName
        let ratingDouble: Double = dependency.item.ratingDouble
        let ratingArray: [Double] = dependency.item.ratingArray
        let userRatingCount: Int = dependency.item.userRatingCount
        let artistName: String = dependency.item.artistName
        let fileSizeBytes: String = dependency.item.fileSizeToFormatting
        let genreName: String = dependency.item.genreName
        let contentRating: String = dependency.item.contentRating
        let version: String = dependency.item.version
        let updateDate: String = dependency.item.updateDateToAgo
        let releaseNotes: String = dependency.item.releaseNotes
        let description: String = dependency.item.description
        let sellerName: String = dependency.item.sellerName
        let isSupported: String = dependency.item.isSupported
        let supported: String = dependency.item.supported
        let languageList: [String] = dependency.item.languageList
        let languages: String = dependency.item.languages
        let trackViewUrl: String = dependency.item.trackViewUrl
        let sellerUrl: String = dependency.item.sellerUrl
        let artistViewUrl: String = dependency.item.artistViewUrl
        let writeReviewUrl: String = dependency.item.writeReviewUrl
        
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
            updateDate: "",
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
        
        self.useCase = dependency?.useCase ?? .init()
        self.coordinator = dependency?.coordinator
    }
}
