//
//  Constants.swift
//  Unsplash-Demo
//
//  Created by Wikipedia Brown on 11/4/19.
//  Copyright © 2019 IamGoodBad. All rights reserved.
//

import UIKit

enum Constants {
    enum CGSizes {
        static var rootCellSize: CGSize {
            let width = (UIScreen.main.bounds.width / 2)
            return CGSize(width: width, height: floor(width * 1.5))
        }
    }
    enum Strings {
        static let accessKey = "Client-ID e7349e163f52a5b59be6b9d9915663d6033551c647007bb80ed4b54b2452b089"
    }
}
