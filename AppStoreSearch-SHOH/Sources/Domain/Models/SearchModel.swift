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
        @DefaultWrapper private(set) var releaseNotes: String
        @DefaultWrapper private(set) var minimumOsVersion: String
        @DefaultWrapper private(set) var currency: String
        @DefaultWrapper private(set) var averageUserRating: Double
        @DefaultWrapper private(set) var userRatingCountForCurrentVersion: Int
        @DefaultWrapper private(set) var trackViewUrl: String
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
        @DefaultWrapper private var trackContentRating: String
        @DefaultWrapper private var contentAdvisoryRating: String
        
        
        private(set) var formattedPrice: String?
        private var fileSizeBytes: String?
        private(set) var sellerUrl: String?
        private(set) var price: Double?
    }
}

// MARK: - Computed Properties

extension SearchModel.Result {
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
        func toInt<T: LazySequenceProtocol>(_ value: T?) -> Int? where T.Element == Character  {
            guard let value = value, let toInt = Int(String(value)) else {
                return nil
            }
            return toInt
        }
        
        let split = slice.lazy
            .split(separator: "x")
            
        var w: Int = 392
        var h: Int = 696
        
        if let first = toInt(split.first) {
            w = first
        }
        if let last = toInt(split.last) {
            h = last
        }
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
    
    var genreName: String {
        return genres.first ?? ""
    }
    
    var contentRating: String {
        if !self.trackContentRating.isEmpty {
            return self.trackContentRating
        }
        return self.contentAdvisoryRating
    }
    
    var updateDateToAgo: String {
        let toDate = Self.ISOFormatter.date(from: self.currentVersionReleaseDate) ?? Date()
        return toDate.ago
    }
    
    var fileSizeToFormatting: String {
        let fileSizeBytes = self.fileSizeBytes ?? ""
        let sizeToInt = Int64(fileSizeBytes) ?? 0
        
        let lazyString = Self.byteFormatter.string(fromByteCount: sizeToInt)
            .lazy
            .filter({ !($0 == " ") })
        
        return String(lazyString)
    }
}

extension SearchModel.Result {
    private static var numberFormatter: NumberFormatter {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        numberFormatter.minimumFractionDigits = 2
        numberFormatter.maximumFractionDigits = 2
        return numberFormatter
    }
    
    private static var byteFormatter: ByteCountFormatter {
        let byteFormatter = ByteCountFormatter()
        byteFormatter.allowedUnits = .useAll
        byteFormatter.includesUnit = true
        return byteFormatter
    }
    
    private static var ISOFormatter: ISO8601DateFormatter {
        return ISO8601DateFormatter()
    }
}
