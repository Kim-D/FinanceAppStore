//
//  Feed.swift
//  FinanceAppStore
//
//  Created by JohnKim on 2017. 11. 25..
//  Copyright © 2017년 KimD. All rights reserved.
//

import Foundation

struct Feed: Codable {
    let title: Contents
    let entry: [AppInfo]
    
    private enum CodingKeys: String, CodingKey {
        case title
        case entry
    }
    
    private enum FeedKeys: String, CodingKey {
        case feed
    }
    
    public init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: FeedKeys.self)
        let feedValues = try values.nestedContainer(keyedBy: CodingKeys.self, forKey: .feed)
       
        title = (try feedValues.decodeIfPresent(Contents.self, forKey: .title))!
        entry = (try feedValues.decodeIfPresent([AppInfo].self, forKey: .entry))!
    }
}

struct AppInfo: Codable {
    let name: Contents
    let image: [Contents]
    let summary: Contents
    let price: Contents
    let contentType: Contents
    let rights: Contents
    let title: Contents
    let link: [Contents]
    let id: Contents
    let artist: Contents
    let category: Contents
    let releaseDate: Contents
    
    private enum CodingKeys: String, CodingKey {
        case name = "im:name"
        case image = "im:image"
        case summary
        case price = "im:price"
        case contentType = "im:contentType"
        case rights
        case title
        case link
        case id
        case artist = "im:artist"
        case category
        case releaseDate = "im:releaseDate"
    }
}

struct Contents: Codable {
    let label: String?
    let duration: Duration?
    let attributes: Attributes?
    
    private enum CodingKeys: String, CodingKey {
        case label
        case duration = "im:duration"
        case attributes
    }
}

struct Duration: Codable {
    let label: String
}

struct Attributes: Codable {
    let height: String?
    let id: String?
    let bundleId: String?
    let term: String?
    let scheme: String?
    let label: String?
    let href: String?
    let type: String?
    let rel: String?
    let currency: String?
    let amount: String?
    let assetType: String?
    
    private enum CodingKeys: String, CodingKey {
        case height
        case id = "im:id"
        case bundleId = "im:bundleId"
        case term
        case scheme
        case label
        case href
        case type
        case rel
        case currency
        case amount
        case assetType = "im:assetType"
    }
}
