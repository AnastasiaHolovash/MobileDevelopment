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
    static let imagesApiKey = "19193969-87191e5db266905fe8936d565"
    
    var urlComponents: URLComponents {
        
        var urlComponents = URLComponents()
        urlComponents.scheme = "http"
        urlComponents.host = "www.omdbapi.com"
        urlComponents.queryItems = [URLQueryItem(name: "apikey", value: MoviesDataManager.apiKEY)]
        return urlComponents
    }
    
    var imagesUrlComponents: URLComponents {
        
        var urlComponents = URLComponents()
        urlComponents.scheme = "https"
        urlComponents.host = "pixabay.com"
        urlComponents.path = "/api/"
        urlComponents.queryItems = [
            URLQueryItem(name: "key", value: MoviesDataManager.imagesApiKey)]
        return urlComponents
    }
    
    public func fetchMoviesList(for searchText: String, page: Int = 1, completion: @escaping(Pagination<Movie>?) -> Void){
        
        let parameters = [
            "s" : "\(searchText)",
            "page" : "\(page)",
            "count" : "10",
        ]
        
        printJson(urlComponents: urlComponents, parameters: parameters)
        
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
        
        printJson(urlComponents: urlComponents, parameters: parameters)
        
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
    
    public func fetchImages(page: Int = 1, completion: @escaping(Hits?) -> Void) {
        
        let parameters = [
            "q" : "​fun+party​",
            "image_type": "photo",
            "per_page" : "30",
            "page" : "\(page)"
        ]
        
        printJson(urlComponents: imagesUrlComponents, parameters: parameters)
        
        AF.request(imagesUrlComponents, parameters: parameters)
            .validate()
            .responseDecodable(of: Hits.self) { response in
                guard let data = response.value else {
                    completion(nil)
                    return
                }
                completion(data)
            }
    }
    
    public func loadImage(url: String, completion: @escaping (UIImage?) -> Void) {
        guard url != "N/A" , let url = URL(string: url) else {
            completion(nil)
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
    
    private func printJson(urlComponents: URLComponents, parameters: [String: String]) {
        
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
