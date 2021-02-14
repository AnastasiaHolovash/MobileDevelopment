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

struct Movie: Codable, Equatable {
    
    let title: String
    let year: String
    let imdbID: String
    let type: String
    let poster: String
    let rated, released, production: String?
    let runtime, genre, director, writer: String?
    let actors, plot, language, country: String?
    let awards, imdbRating, imdbVotes: String?

    enum CodingKeys: String, CodingKey {
        
        case title = "Title"
        case year = "Year"
        case rated = "Rated"
        case released = "Released"
        case runtime = "Runtime"
        case genre = "Genre"
        case director = "Director"
        case writer = "Writer"
        case actors = "Actors"
        case plot = "Plot"
        case language = "Language"
        case country = "Country"
        case awards = "Awards"
        case poster = "Poster"
        case imdbRating, imdbVotes, imdbID
        case type = "Type"
        case production = "Production"
    }
    
    var notEmptyProperties: [(String, String)] {
        
        get {
            let allProperties: [(String, String?)] = [
                ("Year: ", year),
                ("Type: ", type),
                ("Rated: ", rated),
                ("Released: ", released),
                ("Runtime: ", runtime),
                ("Genre: ", genre),
                ("Production: ", production),
                ("Director: ", director),
                ("Writer: ", writer),
                ("Actors: ", actors),
                ("Plot: ", plot),
                ("Language: ", language),
                ("Country: ", country),
                ("Awards: ", awards),
                ("Poster: ", poster),
                ("imdbRating: ", imdbRating),
                ("imdbVotes: ", imdbVotes),]
            
            var result: [(String, String)] = []
            
            allProperties.forEach { (name, item) in
                if let item = item, !item.isEmpty {
                    result.append((name, item))
                }
            }
            
            return result
        }
    }
}

