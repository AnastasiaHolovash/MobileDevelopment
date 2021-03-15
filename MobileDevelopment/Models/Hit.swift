//
//  Hit.swift
//  MobileDevelopment
//
//  Created by Anastasia Holovash on 14.03.2021.
//

import Foundation

// MARK: - Hits
struct Hits: Codable {
    
    var total, totalHits: Int
    var hits: [Hit]
}

extension Hits {
    
    var perPage: Int {
        
        return 30
    }
    
    var nextPage: Int? {
        
        guard hits.count < Int(total) else {
            return nil
        }
        let page = hits.count / perPage + 1
        return page
    }
    
    mutating func merge(with pagination: Hits) {
        
        total = pagination.total
        hits.append(contentsOf: pagination.hits)
    }
}

// MARK: - Hit
struct Hit: Codable, Hashable {
    let id: Int
    let pageURL: String
    let type: String
    let tags: String
    let previewURL: String
    let previewWidth, previewHeight: Int
    let webformatURL: String
    let webformatWidth, webformatHeight: Int
    let largeImageURL: String
    let imageWidth, imageHeight, imageSize, views: Int
    let downloads, favorites, likes, comments: Int
    let userID: Int
    let user: String
    let userImageURL: String

    enum CodingKeys: String, CodingKey {
        case id, pageURL, type, tags, previewURL, previewWidth, previewHeight, webformatURL, webformatWidth, webformatHeight, largeImageURL, imageWidth, imageHeight, imageSize, views, downloads, favorites, likes, comments
        case userID = "user_id"
        case user, userImageURL
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(webformatURL)
    }
}
