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
        imageView.layer.cornerRadius = 8
        imageView.layer.masksToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    let descriptionLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = UIFont.boldSystemFont(ofSize: UIFont.systemFontSize)
        label.textAlignment = .natural
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
        descriptionLabel.text = image?.alt_description
        imageView.backgroundColor = Constants.getColorFrom(hex: image?.color ?? "")
        imageView.image = image?.thumbnailImage
    }
    
    func updateImage(image: UIImage) {
        imageView.image = image
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
