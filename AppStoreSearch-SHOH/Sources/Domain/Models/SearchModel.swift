//
//  SearchModel.swift
//  AppStoreSearch-SHOH
//
//  Created by Jayden OH on 2021/10/21.
//

import Foundation
import SPMSHOHProxy

struct SearchModel: Codable {
    @DefaultWrapper private(set) var resultCount: Int
    let results: [Result]
    
    struct Result: Codable, Hashable {
        @DefaultWrapper private(set) var advisories: [String]
        @DefaultWrapper private(set) var supportedDevices: [String]
        @DefaultWrapper private(set) var isGameCenterEnabled: Bool
        @DefaultWrapper private(set) var screenshotUrls: [String]
        @DefaultWrapper private(set) var ipadScreenshotUrls: [String]
        @DefaultWrapper private(set) var appletvScreenshotUrls: [String]
        @DefaultWrapper private(set) var artworkUrl60: String
        @DefaultWrapper private(set) var artworkUrl100: String
        @DefaultWrapper private(set) var artworkUrl512: String
        @DefaultWrapper private(set) var artistViewUrl: String
        @DefaultWrapper private(set) var kind: String
        @DefaultWrapper private(set) var features: [String]
        @DefaultWrapper private(set) var sellerName: String
        @DefaultWrapper private(set) var primaryGenreId: Int
        @DefaultWrapper private(set) var trackId: Int
        @DefaultWrapper private(set) var trackName: String
        @DefaultWrapper private(set) var releaseDate: String
        @DefaultWrapper private(set) var genreIds: [String]
        @DefaultWrapper private(set) var isVppDeviceBasedLicensingEnabled: Bool
        @DefaultWrapper private(set) var primaryGenreName: String
        @DefaultWrapper private(set) var currentVersionReleaseDate: String
        @DefaultWrapper private(set) var minimumOsVersion: String
        @DefaultWrapper private(set) var currency: String
        @DefaultWrapper private(set) var averageUserRating: Double
        @DefaultWrapper private(set) var contentAdvisoryRating: String
        @DefaultWrapper private(set) var averageUserRatingForCurrentVersion: Double
        @DefaultWrapper private(set) var userRatingCountForCurrentVersion: Int
        @DefaultWrapper private(set) var trackViewUrl: String
        @DefaultWrapper private(set) var trackContentRating: String
        @DefaultWrapper private(set) var trackCensoredName: String
        @DefaultWrapper private(set) var languageCodesISO2A: [String]
        @DefaultWrapper private(set) var version: String
        @DefaultWrapper private(set) var wrapperType: String
        @DefaultWrapper private(set) var genres: [String]
        @DefaultWrapper private(set) var artistId: Int
        @DefaultWrapper private(set) var artistName: String
        @DefaultWrapper private(set) var description: String
        @DefaultWrapper private(set) var bundleId: String
        @DefaultWrapper private(set) var userRatingCount: Int
        
        private(set) var releaseNotes: String?
        private(set) var formattedPrice: String?
        private(set) var fileSizeBytes: String?
        private(set) var sellerUrl: String?
        private(set) var price: Double?
    }
}
