//
//  PhotoManager.swift
//  Unsplash-Demo
//
//  Created by Wikipedia Brown on 11/4/19.
//  Copyright © 2019 IamGoodBad. All rights reserved.
//

import UIKit

protocol ImageManaging: class {
    var selectedImage: Image? { get set }
    func getImage(from string: String, at index: Int,  completion: @escaping (Result<(UIImage, Int), NetworkError>) -> Void)
}

class ImageManager: ImageManaging {
    
    var selectedImage: Image?
    
    private let accessKey = Constants.Strings.accessKey
    private let cache = NSCache<NSString, UIImage>()
    
    init() {}
        
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
