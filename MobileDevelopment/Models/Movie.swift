//
//  Movie.swift
//  MobileDevelopment
//
//  Created by Anastasia Holovash on 09.02.2021.
//

import Foundation

// MARK: - Search

struct Search: Codable {
    
    let search: [Movie]

    enum CodingKeys: String, CodingKey {
        
        case search = "Search"
    }
}

// MARK: - Movie

struct Movie: Codable {
    
    let title: String
    let year: String
    let imdbID: String
    let type: String
    let poster: String

    enum CodingKeys: String, CodingKey {
        
        case title = "Title"
        case year = "Year"
        case imdbID
        case type = "Type"
        case poster = "Poster"
    }
}
