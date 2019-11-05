//
//  ImageURLs.swift
//  Unsplash-Demo
//
//  Created by Wikipedia Brown on 11/4/19.
//  Copyright © 2019 IamGoodBad. All rights reserved.
//

import Foundation

struct ImageURLs: Codable {
    let full: String
    let thumb: String
    
    private enum CodingKeys: String, CodingKey {
        case full
        case thumb
    }
}
