//
//  NetworkManager.swift
//  Unsplash-Demo
//
//  Created by Wikipedia Brown on 11/4/19.
//  Copyright © 2019 IamGoodBad. All rights reserved.
//

import Foundation

protocol NetworkManaging: class {
    func get(from page: Int, query: String, completion: @escaping (Result<ImagePage, NetworkError>) -> Void)
}

class NetworkManager: NetworkManaging {
    
    let accessKey = Constants.Strings.accessKey

    func get(from page: Int, query: String, completion: @escaping (Result<ImagePage, NetworkError>) -> Void)  {
        var components = URLComponents()
        components.scheme = "https"
        components.host = "api.unsplash.com"
        components.path = "/search/photos"
        
        let query = URLQueryItem(name: "query", value: query)

        components.queryItems = [query]
        
        
        guard let url = components.url else { return }
        var request = URLRequest(url: url)
        let session = URLSession.shared
        
        request.httpMethod = "GET"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue(accessKey, forHTTPHeaderField: "Authorization")

        let _ = session.dataTask(with: request) {(data, response, error) in
            
            guard
                let data = data,
                let page = try? JSONDecoder().decode(ImagePage.self, from: data)
            else { return }
            
            switch page {
            case nil:
                completion(.failure(.jsonDecodingError))
                return
            default:
                completion(.success(page))
                return
            }
        }.resume()
    }
    
}
