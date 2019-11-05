//
//  SuggestionsCell.swift
//  Unsplash-Demo
//
//  Created by Wikipedia Brown on 11/5/19.
//  Copyright © 2019 IamGoodBad. All rights reserved.
//

import UIKit

class SuggestionsCell: UICollectionViewCell {
    
    private let label: UILabel = {
        let color = UIColor.systemBlue
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = color
        label.layer.borderColor = color.cgColor
        label.layer.borderWidth = 2
        label.layer.cornerRadius = Constants.CGFloats.suggestedCellHeight / 2
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    func setLabel(with string: String?) {
        label.text = string
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        addSubview(label)
        backgroundColor = .white
        NSLayoutConstraint.activate([
            label.topAnchor.constraint(equalTo: topAnchor),
            label.bottomAnchor.constraint(equalTo: bottomAnchor),
            label.leftAnchor.constraint(equalTo: leftAnchor),
            label.rightAnchor.constraint(equalTo: rightAnchor)
        ])
    }
}
