//
//  SearchRepositoryAPI.swift
//  GitHubRepository
//
//  Created by 심두용 on 2023/06/08.
//

import Foundation

struct SearchRepositoryAPI {
    static let scheme = "https"
    static let host = "api.github.com"
    static let path = "/search/"
    
    func searchBlog(query: String) -> URLComponents {
        var components = URLComponents()
        components.scheme = SearchRepositoryAPI.scheme
        components.host = SearchRepositoryAPI.host
        components.path = SearchRepositoryAPI.path + "repositories"
        
        components.queryItems = [
            URLQueryItem(name: "q", value: query)
        ]
        
        return components
    }
}
