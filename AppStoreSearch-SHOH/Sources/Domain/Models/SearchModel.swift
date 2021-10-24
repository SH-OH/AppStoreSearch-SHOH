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
        
        @DefaultWrapper private var averageUserRatingForCurrentVersion: Double
        
        private(set) var releaseNotes: String?
        private(set) var formattedPrice: String?
        private(set) var fileSizeBytes: String?
        private(set) var sellerUrl: String?
        private(set) var price: Double?
    }
}

// MARK: - Computed Properties

extension SearchModel.Result {
    private static let numberFormatter: NumberFormatter = {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        numberFormatter.minimumFractionDigits = 2
        numberFormatter.maximumFractionDigits = 2
        return numberFormatter
    }()
    
    enum ScreenshotType {
        case high
        case wide
        
        var multiplier: Double {
            switch self {
            case .high:
                return 392.0/696.0
            case .wide:
                return 406.0/228.0
            }
        }
    }
    
    var screenshotType: ScreenshotType {
        guard let slice = self.screenshotUrls.first?.components(separatedBy: "/").last?.dropLast(6) else {
            return .high
        }
        
        let split = slice.split(separator: "x")
        let w = Int(split.first ?? "") ?? 392
        let h = Int(split.last ?? "") ?? 696
        return w > h ? .wide : .high
    }
    
    var ratingDouble: Double {
        guard let averUserRating = Self.numberFormatter
                .string(from: self.averageUserRatingForCurrentVersion as NSNumber),
              let ratingDouble = Double(averUserRating) else { return 0 }
        return ratingDouble
    }
    
    var ratingArray: [Double] {
        var ratingArray: [Double] = []
        for index in 0..<5 {
            var rating = self.ratingDouble-Double(index)
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
        return ratingArray
    }
}
