//
//  MoviesDataManager.swift
//  MobileDevelopment
//
//  Created by Anastasia Holovash on 11.02.2021.
//

import UIKit

final class MoviesDataManager {
    
    static let shared = MoviesDataManager()
    
    private init() { }
    
    public let moviesList = "MoviesList"
    
    public func fetchMoviesList() -> [Movie]? {
        
        do {
            if let path = Bundle.main.path(forResource: moviesList, ofType: "txt"),
               let jsonData = try String(contentsOfFile: path, encoding: String.Encoding.utf8).data(using: .utf8) {
                
                let decodedData = try JSONDecoder().decode(Search.self, from: jsonData)
                return decodedData.search
            }
        } catch {
            print(error)
        }
        return nil
    }
    
    public func fetchMovieImage(for imageName: String) -> UIImage? {
        
        guard let image = UIImage(named: imageName) else {
            return nil
        }
        return image
    }
    
    public func fetchMovieData(for id: String) -> Movie? {
        
        do {
            if let path = Bundle.main.path(forResource: id, ofType: "txt"),
               let jsonData = try String(contentsOfFile: path, encoding: String.Encoding.utf8).data(using: .utf8) {
                
                let decodedData = try JSONDecoder().decode(Movie.self, from: jsonData)
                return decodedData
            }
        } catch {
            print(error)
        }
        return nil
    }
}
