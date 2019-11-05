//
//  RootViewController.swift
//  Unsplash-Demo
//
//  Created by Wikipedia Brown on 11/4/19.
//  Copyright © 2019 IamGoodBad. All rights reserved.
//

import RIBs
import RxSwift
import UIKit

protocol RootPresentableListener: class {
    // TODO: Declare properties and methods that the view controller can invoke to perform
    // business logic, such as signIn(). This protocol is implemented by the corresponding
    // interactor class.
    func onCountRequest() -> Int
    func onRegularImageRequest(at index: Int) -> Image
    func onFullImageRequest(at index: Int) -> Image
}

final class RootViewController: UIViewController, RootPresentable, RootViewControllable {
    
    let searchController = UISearchController(searchResultsController: nil)
    
    private let collectionView = RootCollectionView()
    
    var isSearchBarEmpty: Bool {
      return searchController.searchBar.text?.isEmpty ?? true
    }

    weak var listener: RootPresentableListener?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }
    
    func updateData() {
        DispatchQueue.main.async { [weak self] in
            self?.collectionView.reloadData()
        }
    }
    
    func presentImage(image: UIImage, at index: Int) {
        guard let cell = collectionView.cellForItem(at: IndexPath(item: index, section: 0)),
        let rootCell = cell as? RootCell
        else { return }
        DispatchQueue.main.async { [weak self] in
            rootCell.updateImage(image: image)
//            self?.collectionView.reloadData()
        }
    }
    
    private func setupViews() {
        view.addSubview(collectionView)
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            collectionView.leftAnchor.constraint(equalTo: view.leftAnchor),
            collectionView.rightAnchor.constraint(equalTo: view.rightAnchor)
        ])
        
        collectionView.dataSource = self
        collectionView.delegate = self

        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search Candies"
        
        navigationItem.searchController = searchController
        definesPresentationContext = true
        
    }
}

extension RootViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return listener?.onCountRequest() ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return collectionView.dequeueReusableCell(withReuseIdentifier: RootCell.description(), for: indexPath)
    }
    
}

extension RootViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        
        guard let cell = cell as? RootCell else { return }
        let image = listener?.onRegularImageRequest(at: indexPath.item)
        cell.displayImage(image: image)
        
    }
}

extension RootViewController: UISearchResultsUpdating {
  func updateSearchResults(for searchController: UISearchController) {
    // TODO
  }
}
