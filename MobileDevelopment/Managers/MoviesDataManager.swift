//
//  MoviesDataManager.swift
//  MobileDevelopment
//
//  Created by Anastasia Holovash on 11.02.2021.
//

import UIKit
import Alamofire

final class MoviesDataManager {
    
    static let shared = MoviesDataManager()
    
    private init() { }
    
    static let apiKEY = "779d5b49"
    
    var urlComponents: URLComponents {
        
        var urlComponents = URLComponents()
        urlComponents.scheme = "http"
        urlComponents.host = "www.omdbapi.com"
        urlComponents.queryItems = [URLQueryItem(name: "apikey", value: MoviesDataManager.apiKEY)]
        return urlComponents
    }
    
    public func fetchMoviesList(for searchText: String, page: Int = 1, completion: @escaping(Pagination<Movie>?) -> Void){
        
        let parameters = [
            "s" : "\(searchText)",
            "page" : "\(page)",
            "count" : "20",
        ]
        printJson(parameters: parameters)
        
        AF.request(urlComponents, parameters: parameters)
            .validate()
            .responseDecodable(of: Pagination<Movie>.self) { response in
                
                guard let data = response.value else {
                    completion(nil)
                    return
                }
                completion(data)
            }
    }
    
    public func fetchMovie(for id: String, completion: @escaping(Movie?) -> Void) {
        
        let parameters = [
            "i" : "\(id)",
        ]
        
        printJson(parameters: parameters)
        
        AF.request(urlComponents, parameters: parameters)
            .validate()
            .responseDecodable(of: Movie.self) { response in
                guard let data = response.value else {
                    completion(nil)
                    return
                }
                completion(data)
            }
    }
    
    func loadImage(url: String, completion: @escaping (UIImage?) -> Void) {
        guard let url = URL(string: url) else {
            return
        }
        AF.request(url)
            .validate()
            .responseData { response in
                guard let data = response.value, let image = UIImage(data: data) else {
                    completion(nil)
                    return
                }
                completion(image)
            }
    }
    
    func printJson(parameters: [String: String]) {
        
        AF.request(urlComponents, parameters: parameters)
            .validate()
            .responseData { response in
                if let data = response.value,
                   let json = try? JSONSerialization.jsonObject(with: data, options: .mutableContainers),
                   let jsonData = try? JSONSerialization.data(withJSONObject: json, options: .prettyPrinted) {
                    print(String(decoding: jsonData, as: UTF8.self))
                } else {
                    print("JSON data incorrect")
                }
            }
    }
}
