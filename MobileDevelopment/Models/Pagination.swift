//
//  Pagination.swift
//  MobileDevelopment
//
//  Created by Anastasia Holovash on 12.03.2021.
//

import Foundation

struct Pagination<Parsable: Decodable>: Decodable {
    
    enum CodingKeys: String, CodingKey {
        case totalResults
        case items = "Search"
        case response = "Response"
    }
    
    var response: String
    var totalResults: String
    var items: [Parsable]
}


extension Pagination {
    
    var perPage: Int {
        
        return 20
    }
    
    var nextPage: Int? {
        
        guard items.count < Int(totalResults) ?? 0 else {
            return nil
        }
        let page = items.count / perPage + 1
        return page
    }
    
    mutating func merge(with pagination: Pagination<Parsable>) {
        
        totalResults = pagination.totalResults
        items.append(contentsOf: pagination.items)
    }
}
