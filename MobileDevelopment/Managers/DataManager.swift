//
//  DataManager.swift
//  MobileDevelopment
//
//  Created by Anastasia Holovash on 11.02.2021.
//

import UIKit
import Alamofire

final class DataManager {
    
    static let shared = DataManager()
    
    private init() { }
    
    static let apiKEY = "779d5b49"
    static let imagesApiKey = "19193969-87191e5db266905fe8936d565"
    
    var urlComponents: URLComponents {
        
        var urlComponents = URLComponents()
        urlComponents.scheme = "http"
        urlComponents.host = "www.omdbapi.com"
        urlComponents.queryItems = [URLQueryItem(name: "apikey", value: DataManager.apiKEY)]
        return urlComponents
    }
    
    var imagesUrlComponents: URLComponents {
        
        var urlComponents = URLComponents()
        urlComponents.scheme = "https"
        urlComponents.host = "pixabay.com"
        urlComponents.path = "/api/"
        urlComponents.queryItems = [
            URLQueryItem(name: "key", value: DataManager.imagesApiKey)]
        return urlComponents
    }
    
    private func fetch<Type: Decodable>(urlComponents: URLComponents, parameters: [String: String], completion: @escaping(Type?) -> Void) {
        
        AF.request(urlComponents, parameters: parameters)
            .validate()
            .responseDecodable(of: Type.self) { response in
                guard let data = response.value else {
                    completion(nil)
                    return
                }
                completion(data)
            }
    }
    
    public func fetchMoviesList(for searchText: String, page: Int = 1, completion: @escaping(Pagination<Movie>?) -> Void){
        
        let parameters = [
            "s" : "\(searchText)",
            "page" : "\(page)",
            "count" : "10",
        ]
        fetch(urlComponents: urlComponents, parameters: parameters, completion: completion)
    }
    
    public func fetchMovie(for id: String, completion: @escaping(Movie?) -> Void) {
        
        let parameters = [
            "i" : "\(id)",
        ]
        fetch(urlComponents: urlComponents, parameters: parameters, completion: completion)
    }
    
    public func fetchImages(page: Int = 1, completion: @escaping(Hits?) -> Void) {
        
        let parameters = [
            "q" : "​fun+party",
            "image_type": "photo",
            "per_page" : "30",
            "page" : "\(page)"
        ]
        fetch(urlComponents: imagesUrlComponents, parameters: parameters, completion: completion)
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
                    print(response.error as Any)
                }
            }
    }
}
