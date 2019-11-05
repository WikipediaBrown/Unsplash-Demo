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
    func onNextPage()
    func onSearch(with query: String)
    func onSelect(at index: Int)
}

final class RootViewController: UIViewController, RootPresentable, RootViewControllable {
        
    private let collectionView = RootCollectionView()
    
    private let containerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let searchController: UISearchController = {
        let searchController = UISearchController(searchResultsController: nil)
        return searchController
    }()

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
        DispatchQueue.main.async { [weak self] in
            guard
                let cell = self?.collectionView.cellForItem(at: IndexPath(item: index, section: 0)),
                let rootCell = cell as? RootCell
            else { return }
            rootCell.updateImage(image: image)
        }
    }
    
    private func setupViews() {
        let searchBar = searchController.searchBar
        
        containerView.addSubview(searchBar)

        view.addSubview(containerView)
        view.addSubview(collectionView)

        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            containerView.leftAnchor.constraint(equalTo: view.leftAnchor),
            containerView.rightAnchor.constraint(equalTo: view.rightAnchor),
            containerView.heightAnchor.constraint(equalToConstant: UIScreen.main.bounds.height / 9)
        ])
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: containerView.bottomAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            collectionView.leftAnchor.constraint(equalTo: view.leftAnchor),
            collectionView.rightAnchor.constraint(equalTo: view.rightAnchor)
        ])
        
        collectionView.dataSource = self
        collectionView.delegate = self

        searchController.searchResultsUpdater = self
        searchController.hidesNavigationBarDuringPresentation = false
        
        searchBar.delegate = self

//        searchController.obscuresBackgroundDuringPresentation = false
        
//        searchController.obscuresBackgroundDuringPresentation = false
//        searchController.searchBar.placeholder = "Search Candies"
//
//        navigationItem.searchController = searchController
//        definesPresentationContext = true
        
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
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        listener?.onSelect(at: indexPath.item)
    }
    
}

extension RootViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let threshold: CGFloat = 100.0
        let contentOffset = scrollView.contentOffset.y
        let maximumOffset = scrollView.contentSize.height - scrollView.frame.size.height;
        if (maximumOffset - contentOffset <= threshold) && (maximumOffset - contentOffset != -5.0) {            listener?.onNextPage()
        }
    }
}

extension RootViewController: UISearchResultsUpdating {
  func updateSearchResults(for searchController: UISearchController) {
    print(searchController.searchBar.text)
  }
}

extension RootViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let text = searchBar.text else { return }
        
        searchController.isActive = false
        
        switch text {
        case "":
            break
        default:
            listener?.onSearch(with: text)
        }
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        
    }
}
