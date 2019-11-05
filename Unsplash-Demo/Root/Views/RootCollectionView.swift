//
//  RootCollectionView.swift
//  Unsplash-Demo
//
//  Created by Wikipedia Brown on 11/4/19.
//  Copyright © 2019 IamGoodBad. All rights reserved.
//

import UIKit

class RootCollectionView: UICollectionView {

    init() {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = Constants.CGSizes.rootCellSize
        layout.scrollDirection = .vertical
        layout.sectionInset = .zero
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        super.init(frame: .zero, collectionViewLayout: layout)
                backgroundColor = .white
        contentInset = .zero
        register(RootCell.self, forCellWithReuseIdentifier: RootCell.description())
        translatesAutoresizingMaskIntoConstraints = false
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
