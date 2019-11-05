//
//  ImagePage.swift
//  Unsplash-Demo
//
//  Created by Wikipedia Brown on 11/4/19.
//  Copyright © 2019 IamGoodBad. All rights reserved.
//

import Foundation

struct ImagePage: Codable {
    let results: [Image]
    let total: Int
    let total_pages: Int
    
    private enum CodingKeys: String, CodingKey {
        case results
        case total
        case total_pages
    }
}
