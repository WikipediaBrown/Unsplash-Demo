//
//  Image.swift
//  Unsplash-Demo
//
//  Created by Wikipedia Brown on 11/4/19.
//  Copyright © 2019 IamGoodBad. All rights reserved.
//

import UIKit

struct Image: Codable {
    var alt_description: String?
    var description: String?
    let color: String
    let urls: ImageURLs
    var thumbnailImage: UIImage?
    var fullImage: UIImage?
    
    private enum CodingKeys: String, CodingKey {
        case alt_description
        case description
        case color
        case urls
    }
}
