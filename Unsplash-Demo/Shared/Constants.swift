//
//  Constants.swift
//  Unsplash-Demo
//
//  Created by Wikipedia Brown on 11/4/19.
//  Copyright © 2019 IamGoodBad. All rights reserved.
//

import UIKit

enum Constants {
    enum CGFloats {
        static let suggestedCellHeight: CGFloat = 25
    }
    enum CGSizes {
        static var rootCellSize: CGSize {
            let width = floor(UIScreen.main.bounds.width / 2)
            return CGSize(width: width, height: floor(width * 1.5))
        }
    }
    enum Strings {
        static let accessKey = "Client-ID e7349e163f52a5b59be6b9d9915663d6033551c647007bb80ed4b54b2452b089"
    }
    
    static func getColorFrom(hex: String) -> UIColor {
        guard hex.count == 7 else { return .blue }
        
        let redStart = hex.index(hex.startIndex, offsetBy: 1)
        let redEnd = hex.index(hex.startIndex, offsetBy: 2)
        let greenStart = hex.index(hex.startIndex, offsetBy: 3)
        let greenEnd = hex.index(hex.startIndex, offsetBy: 4)
        let blueStart = hex.index(hex.startIndex, offsetBy: 5)
        let blueEnd = hex.index(hex.startIndex, offsetBy: 6)

        let redHex = String(hex[redStart...redEnd])
        let greenHex = String(hex[greenStart...greenEnd])
        let blueHex = String(hex[blueStart...blueEnd])
        
        let red = CGFloat(Int(redHex, radix: 16) ?? 255) / 255
        let green = CGFloat(Int(greenHex, radix: 16) ?? 255) / 255
        let blue = CGFloat(Int(blueHex, radix: 16) ?? 255) / 255

        return UIColor(red: CGFloat(red), green: CGFloat(green), blue: CGFloat(blue), alpha: 1)
    }
}
