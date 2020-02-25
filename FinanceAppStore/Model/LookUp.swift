//
//  LookUp.swift
//  FinanceAppStore
//
//  Created by JohnKim on 2017. 11. 26..
//  Copyright © 2017년 KimD. All rights reserved.
//

import Foundation

struct LookUp: Codable {
    let resultCount: Int
    let results:[AppDetailInfo]
}

struct AppDetailInfo: Codable {
    let isGameCenterEnabled: Bool?
    let ipadScreenshotUrls: [String]?
    let appletvScreenshotUrls: [String]?
    let artworkUrl60: String?
    let artworkUrl512: String?
    let artworkUrl100: String?
    let artistViewUrl: String?
    let kind: String?
    let features: [String]?
    let supportedDevices: [String]?
    let screenshotUrls: [String]?
    let advisories: [String]?
    let averageUserRatingForCurrentVersion: Float?
    let trackCensoredName: String?
    let languageCodesISO2A: [String]?
    let fileSizeBytes: String?
    let sellerUrl: String?
    let contentAdvisoryRating: String?
    let userRatingCountForCurrentVersion: Int?
    let trackViewUrl: String?
    let trackContentRating: String?
    let sellerName: String?
    let formattedPrice: String?
    let genreIds: [String]?
    let minimumOsVersion: String?
    let currentVersionReleaseDate: String?
    let releaseNotes: String?
    let currency: String?
    let wrapperType: String?
    let version: String?
    let artistId: Int?
    let artistName: String?
    let genres: [String]?
    let price: Float?
    let description: String?
    let bundleId: String?
    let primaryGenreName: String?
    let isVppDeviceBasedLicensingEnabled: Bool?
    let releaseDate: String?
    let primaryGenreId: Int?
    let averageUserRating: Float?
    let userRatingCount: Int?
    let trackId: Int?
}
