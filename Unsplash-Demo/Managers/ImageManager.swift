//
//  PhotoManager.swift
//  Unsplash-Demo
//
//  Created by Wikipedia Brown on 11/4/19.
//  Copyright © 2019 IamGoodBad. All rights reserved.
//

import UIKit

protocol ImageManaging: class {
    func getImage(from string: String, at index: Int,  completion: @escaping (Result<(UIImage, Int), NetworkError>) -> Void)
}

class ImageManager: ImageManaging {
    init() {
    }
    
    private let accessKey = Constants.Strings.accessKey
    private let cache = NSCache<NSString, UIImage>()
        
    func getImage(from string: String, at index: Int,  completion: @escaping (Result<(UIImage, Int), NetworkError>) -> Void) {
        
        if let image = cache.object(forKey: string as NSString) {
            completion(.success((image, index)))
            return
        }

        DispatchQueue.global(qos: .userInteractive).async { [weak self] in
            guard
                let url = URL(string: string),
                let data = try? Data(contentsOf: url),
                let image = UIImage(data: data)
            else { completion(.failure(.imageDecodingError)); return }

            self?.cache.setObject(image, forKey: string as NSString)
            completion(.success((image, index)))
            return
        }
        
    }

}
//func get(from page: Int, query: String, completion: @escaping (Result<ImagePage, NetworkError>) -> Void)  {
//    var components = URLComponents()
//    components.scheme = "https"
//    components.host = "api.unsplash.com"
//    components.path = "/search/photos"
//
//    let query = URLQueryItem(name: "query", value: query)
//
//    components.queryItems = [query]
//
//
//    guard let url = components.url else { return }
//    var request = URLRequest(url: url)
//    let session = URLSession.shared
//
//    request.httpMethod = "GET"
//    request.addValue("application/json", forHTTPHeaderField: "Content-Type")
//    request.addValue("application/json", forHTTPHeaderField: "Accept")
//    request.addValue(accessKey, forHTTPHeaderField: "Authorization")
//
//    let _ = session.dataTask(with: request) {(data, response, error) in
//
//        guard
//            let data = data,
//            let page = try? JSONDecoder().decode(ImagePage.self, from: data)
//        else { return }
//
//        switch page {
//        case nil:
//            completion(.failure(.jsonDecodingError))
//            break
//        default:
//            completion(.success(page))
//            break
//        }
//    }.resume()
//}
