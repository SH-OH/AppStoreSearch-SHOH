//
//  SearchResultDetailViewReactor.swift
//  AppStoreSearch-SHOH
//
//  Created by Jayden OH on 2021/10/23.
//

import Foundation

import SPMSHOHProxy
import DeviceKit
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
        var trackId: Int
        var artworkUrl100: String
        var trackName: String
        var ratingDouble: Double
        var ratingArray: [Double]
        var userRatingCount: Int
        var artistName: String
        var fileSizeToFormatting: String
        var genreName: String
        var contentRating: String
        var version: String
        var updateDateToAgo: String
        var releaseNotes: String
        var description: String
        var supportedDeviceTypes: [SupportDevice]
        var isSupportedCurrentDevice: String
        var currentLanguageCode: String
        var summaryLanguage: String
        var infoTitleLanguage: String
        var infoSubTextLanguage: String
        var isShowInfoSubText: Bool
        var trackViewUrl: String
        var sellerUrl: String
        var writeReviewUrl: String
        var screenshotType: ScreenshotType
        var screenshotUrls: [String]
    }
    
    let initialState: State
    private let useCase: SearchUseCase
    let coordinator: CoordinatorType?
    
    init(with dependency: DependencyType) {
        let dependency = dependency.cast(Dependency.self)
        let item = dependency.item
        
        let ratingDouble: Double = item.ratingDouble
        let ratingArray: [Double] = item.ratingArray
        let fileSizeToFormatting: String = dependency.createFileSizeToFormatting(
            fileSizeBytes: item.fileSizeBytes
        )
        let updateDateToAgo: String = dependency.createUpdateDateToAgo(
            currentVersionReleaseDate: item.currentVersionReleaseDate
        )
        let supportedDeviceTypes: [SupportDevice] = dependency.createSupportedTypes(
            minimumOsVersion: item.minimumOsVersion,
            screenshotUrls: item.screenshotUrls,
            ipadScreenshotUrls: item.ipadScreenshotUrls,
            supportedDevices: item.supportedDevices
        )
        let isSupportedCurrentDevice: String = dependency.createIsSupportedCurrentDevice(
            minimumOsVersion: item.minimumOsVersion,
            supportedDeviceTypes: supportedDeviceTypes
        )
        let (languageCode, summary, infoTitle, infoSubText, isShowInfoSubText) = dependency.createSupportedLanguages(
            languageCodesISO2A: item.languageCodesISO2A
        )
        let writeReviewUrl: String = Domain.review(id: item.trackId)
        
        
        self.initialState = .init(
            trackId: item.trackId,
            artworkUrl100: item.artworkUrl100,
            trackName: item.trackName,
            ratingDouble: ratingDouble,
            ratingArray: ratingArray,
            userRatingCount: item.userRatingCount,
            artistName: dependency.artistName,
            fileSizeToFormatting: fileSizeToFormatting,
            genreName: item.genres.first ?? "",
            contentRating: dependency.contentRating,
            version: item.version,
            updateDateToAgo: updateDateToAgo,
            releaseNotes: item.releaseNotes ?? "",
            description: item.description,
            supportedDeviceTypes: supportedDeviceTypes,
            isSupportedCurrentDevice: isSupportedCurrentDevice,
            currentLanguageCode: languageCode,
            summaryLanguage: summary,
            infoTitleLanguage: infoTitle,
            infoSubTextLanguage: infoSubText,
            isShowInfoSubText: isShowInfoSubText,
            trackViewUrl: item.trackViewUrl,
            sellerUrl: item.sellerUrl ?? "",
            writeReviewUrl: writeReviewUrl,
            screenshotType: item.screenshotType,
            screenshotUrls: item.screenshotUrls
        )
        
        self.useCase = dependency.useCase
        self.coordinator = dependency.coordinator
    }
}

// MARK: - Dependency Model Convert Logic

extension SearchResultDetailViewReactor.Dependency {
    var artistName: String {
        if !item.artistName.isEmpty {
            return item.artistName
        }
        return item.sellerName
    }
    
    var contentRating: String {
        if !item.trackContentRating.isEmpty {
            return item.trackContentRating
        }
        return item.contentAdvisoryRating
    }
    
    func createUpdateDateToAgo(currentVersionReleaseDate: String) -> String {
        let toDate = Self.ISOFormatter.date(from: currentVersionReleaseDate) ?? Date()
        return toDate.ago
    }
    
    func createSupportedTypes(
        minimumOsVersion: String,
        screenshotUrls: [String],
        ipadScreenshotUrls: [String],
        supportedDevices: [String]
    ) -> [SupportDevice] {
        let minimumOsVersion = minimumOsVersion
        var isSupportedPhone: Bool = false
        var isSupportedPad: Bool?
        var isSupportedPod: Bool?
        
        let isEmptyScreenshotUrls: Bool = screenshotUrls.isEmpty
        let isEmptyiPadScreenshotUrls: Bool = ipadScreenshotUrls.isEmpty
        var devices: [SupportDevice] = []
        
        func create(_ deviceType: DeviceType, minOsVersion: String) -> SupportDevice {
            let description = "\(deviceType.os) \(minimumOsVersion) 이상 필요."
            let supportDevice = SupportDevice(deviceType: deviceType, description: description)
            return supportDevice
        }
        
        for device in supportedDevices.lazy {
            if isSupportedPhone && isSupportedPad != nil && isSupportedPod != nil {
                break
            }
            
            if device.contains(DeviceType.iPhone.rawValue), !isSupportedPhone, !isEmptyScreenshotUrls {
                let supportDevice = create(.iPhone, minOsVersion: minimumOsVersion)
                devices.append(supportDevice)
                isSupportedPhone = true
                
            } else if device.contains(DeviceType.iPad.rawValue), isSupportedPad == nil {
                let supportDevice = create(.iPad, minOsVersion: minimumOsVersion)
                devices.append(supportDevice)
                isSupportedPad = !isEmptyiPadScreenshotUrls
                
            } else if device.contains(DeviceType.iPod.rawValue), isSupportedPod == nil {
                let supportDevice = create(.iPod, minOsVersion: minimumOsVersion)
                devices.append(supportDevice)
                isSupportedPod = !isEmptyScreenshotUrls
                
            }
        }
        
        return devices
    }
    
    func createIsSupportedCurrentDevice(
        minimumOsVersion: String,
        supportedDeviceTypes: [SupportDevice]
    ) -> String {
        let compareVersion = UIDevice.current.systemVersion
            .compare(minimumOsVersion, options: .numeric)
        let compare: Bool = compareVersion != .orderedAscending
        
        let supportedDeviceTypes = supportedDeviceTypes
        let device = Device.current
        let isSupported: Bool
        
        let model = UIDevice.current.model
        let available: String = "이 \(model)와(과) 호환"
        let disavailable: String = "이 앱은 \(supportedDeviceTypes.first?.deviceType.title ?? model)의 App Store에서만 사용할 수 있습니다."
        
        if !compare {
            return disavailable
        }
        
        if device.isPhone, supportedDeviceTypes.first(where: { $0.deviceType == .iPhone }) != nil {
            isSupported = true
        } else if device.isPad, supportedDeviceTypes.first(where: { $0.deviceType == .iPad }) != nil {
            isSupported = true
        } else if device.isPod, supportedDeviceTypes.first(where: { $0.deviceType == .iPod }) != nil {
            isSupported = true
        } else {
            isSupported = false
        }
        
        return isSupported ? available : disavailable
    }
    
    func createFileSizeToFormatting(fileSizeBytes: String?) -> String {
        let fileSizeBytes = fileSizeBytes ?? ""
        let sizeToInt = Int64(fileSizeBytes) ?? 0
        
        let lazyString = Self.byteFormatter.string(fromByteCount: sizeToInt)
            .lazy
            .filter({ !($0 == " ") })
        
        return String(lazyString)
    }
    
    func createSupportedLanguages(languageCodesISO2A: [String]) -> (String, String, String, String, Bool) {
        let currentCode = Locale.current.languageCode?.uppercased() ?? "KO"
        let languageCode = languageCodesISO2A.contains(currentCode) ? currentCode : languageCodesISO2A.first ?? "KO"
        
        let languageList = languageCodesISO2A.lazy
            .compactMap({ (code) -> String? in
                let locale = Locale(identifier: code)
                return (locale as NSLocale)
                    .displayName(forKey: .identifier, value: locale.identifier)
            })
        
        let summary: String
        let infoTitle: String
        let infoSubText: String
        
        let defaultLocale = Locale(identifier: languageCode)
        let displayName = (defaultLocale as NSLocale)
            .displayName(forKey: .identifier, value: defaultLocale.identifier) ?? "한국어"
        
        let count = languageList.count
        
        switch count {
        case 2:
            summary = "+ 1개 언어"
            let text = languageList.joined(separator:  " 및 ")
            infoTitle = text
            infoSubText = text
            
        case 3...:
            let count = count-1
            let text = "+ \(count)개 언어"
            summary = text
            infoTitle = "\(displayName) 외 \(count)개"
            infoSubText = text
            
        default:
            summary = displayName
            infoTitle = displayName
            infoSubText = displayName
        }
        
        let isShowInfoSubText = count > 2
        return (languageCode, summary, infoTitle, infoSubText, isShowInfoSubText)
        
    }
}

extension SearchResultDetailViewReactor.Dependency {
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
