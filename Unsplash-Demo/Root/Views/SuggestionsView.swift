//
//  SuggestionsCollectionView.swift
//  Unsplash-Demo
//
//  Created by Wikipedia Brown on 11/5/19.
//  Copyright © 2019 IamGoodBad. All rights reserved.
//

import UIKit

protocol SuggestionsViewListening: class {
    func searchWith(string: String)
}

class SuggestionsView: UICollectionView {
    
    var listener: SuggestionsViewListening?
    var queryHistory = [String?]()
    var querySuggestions = [String?]()
    
    init() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 4
        
        super.init(frame: .zero, collectionViewLayout: layout)
        alwaysBounceHorizontal = true
        backgroundColor = .white
        dataSource = self
        delegate = self
        register(SuggestionsCell.self, forCellWithReuseIdentifier: SuggestionsCell.description())
        isScrollEnabled = true
        isUserInteractionEnabled = true
        translatesAutoresizingMaskIntoConstraints = false
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func loadHistory(history: [String?]) {
        queryHistory = history
        reloadData()
    }
    
    func loadSuggestions(suggestions: [String]) {
        querySuggestions = suggestions
    }
    
}

extension SuggestionsView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch section {
        case 0:
            return queryHistory.count
        default:
            return querySuggestions.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return collectionView.dequeueReusableCell(withReuseIdentifier: SuggestionsCell.description(), for: indexPath)
    }
}

extension SuggestionsView: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        guard let cell = cell as? SuggestionsCell else { return }
        
        switch indexPath.section {
        case 0:
            let string = queryHistory[indexPath.item]
            cell.setLabel(with: string)
        default:
            break
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let string: String
        switch indexPath.section {
        case 0:
            string = queryHistory[indexPath.item] ?? ""
        default:
            string = querySuggestions[indexPath.item] ?? ""
        }
        listener?.searchWith(string: string)
    }
}

extension SuggestionsView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let string: String
        let width: CGFloat
        let height: CGFloat = Constants.CGFloats.suggestedCellHeight
        let fontSize = UIFont.systemFontSize
        let attributes: [NSAttributedString.Key: Any] = [.font: UIFont.systemFont(ofSize: fontSize)]
        
        switch indexPath.section {
        case 0:
            string = queryHistory[indexPath.item] ?? ""
        default:
            string = querySuggestions[indexPath.item] ?? ""
        }
        
        width = NSString(string: string).size(withAttributes: attributes).width + 20
        return CGSize(width: width, height: height)
    }
}
