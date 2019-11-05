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
        label.font = UIFont.systemFont(ofSize: UIFont.systemFontSize)
        label.textAlignment = .center
        label.textColor = color
        label.baselineAdjustment = .none
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
        contentView.layer.borderColor = UIColor.systemBlue.cgColor
        contentView.layer.borderWidth = 2
        contentView.layer.cornerRadius = Constants.CGFloats.suggestedCellHeight / 2
        contentView.addSubview(label)
        contentView.backgroundColor = .white
        NSLayoutConstraint.activate([
            label.topAnchor.constraint(equalTo: contentView.layoutMarginsGuide.topAnchor),
            label.bottomAnchor.constraint(equalTo: contentView.layoutMarginsGuide.bottomAnchor),
            label.leftAnchor.constraint(equalTo: contentView.layoutMarginsGuide.leftAnchor),
            label.rightAnchor.constraint(equalTo: contentView.layoutMarginsGuide.rightAnchor)
        ])
    }
}
