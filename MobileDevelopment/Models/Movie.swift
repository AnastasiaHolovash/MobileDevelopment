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
    let rated, released: String?
    let runtime, genre, director, writer: String?
    let actors, plot, language, country: String?
    let awards: String?
    let ratings: [Rating]?
    let metascore, imdbRating, imdbVotes: String?
    let dvd, boxOffice, production: String?
    let website, response: String?
    
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
        case ratings = "Ratings"
        case metascore = "Metascore"
        case imdbRating, imdbVotes, imdbID
        case type = "Type"
        case dvd = "DVD"
        case boxOffice = "BoxOffice"
        case production = "Production"
        case website = "Website"
        case response = "Response"
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
                ("Ratings: ", Rating.arrayToString(ratings)),
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

// MARK: - Rating

struct Rating: Codable, Equatable {
    let source, value: String

    enum CodingKeys: String, CodingKey {
        case source = "Source"
        case value = "Value"
    }
    
    var stringDescribing: String {
        get {
            return "\(source): \(value)\n"
        }
    }
    
    static func arrayToString(_ arr: [Rating]?) -> String? {
        guard let arr = arr, !arr.isEmpty else {
            return nil
        }
        var string = arr.reduce("", { $0 + $1.stringDescribing })
        string.removeLast(2)
        return string
    }
}
