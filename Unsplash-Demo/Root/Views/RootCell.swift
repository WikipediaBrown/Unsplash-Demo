//
//  RootCell.swift
//  Unsplash-Demo
//
//  Created by Wikipedia Brown on 11/4/19.
//  Copyright © 2019 IamGoodBad. All rights reserved.
//

import UIKit

class RootCell: UICollectionViewCell {
    
    let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    let descriptionLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func displayImage(image: Image?) {
        descriptionLabel.text = image?.description
        imageView.backgroundColor = getColorFrom(hex: image?.color ?? "")
        imageView.image = image?.thumbnailImage
    }
    
    func updateImage(image: UIImage) {
        imageView.image = image
    }
    
    private func getColorFrom(hex: String) -> UIColor {
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
    
    private func setupViews() {
        addSubview(descriptionLabel)
        addSubview(imageView)
        backgroundColor = .white

        let labelHeight = UIScreen.main.bounds.width / 4

        NSLayoutConstraint.activate([
            descriptionLabel.bottomAnchor.constraint(equalTo: bottomAnchor),
            descriptionLabel.leftAnchor.constraint(equalTo: leftAnchor),
            descriptionLabel.rightAnchor.constraint(equalTo: rightAnchor),
            descriptionLabel.heightAnchor.constraint(equalToConstant: labelHeight)
        ])
        
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: layoutMarginsGuide.topAnchor),
            imageView.bottomAnchor.constraint(equalTo: descriptionLabel.topAnchor, constant: -10),
            imageView.leftAnchor.constraint(equalTo: layoutMarginsGuide.leftAnchor),
            imageView.rightAnchor.constraint(equalTo: layoutMarginsGuide.rightAnchor)
        ])
    
    }
    
}
