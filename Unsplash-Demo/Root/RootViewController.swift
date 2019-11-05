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
    func onNextPage()
    func onSearch(with query: String)
    func onSelect(at index: Int)
    func onSwitchToSearch(filterWord: String?) -> String
    func onSwitchToFilter(searchWord: String?) -> String
    func onFilter(filterWord: String)
}

final class RootViewController: UIViewController, RootPresentable, RootViewControllable {
        
    private let collectionView = RootCollectionView()
    private let searchController = UISearchController(searchResultsController: nil)
    private let suggestionsView = SuggestionsView()
    
    private let containerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let segmentedControl: UISegmentedControl = {
        let control = UISegmentedControl()
        control.insertSegment(withTitle: "Search", at: 0, animated: false)
        control.insertSegment(withTitle: "Filter", at: 1, animated: false)
        control.selectedSegmentIndex = 0
        control.translatesAutoresizingMaskIntoConstraints = false
        return control
    }()

    weak var listener: RootPresentableListener?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
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
    
    func updateData() {
        DispatchQueue.main.async { [weak self] in
            self?.collectionView.reloadData()
        }
    }
    
    func updateHistory(with history: [String?]) {
        DispatchQueue.main.async { [weak self] in
            self?.suggestionsView.loadHistory(history: history)
        }
    }
    
    func searchSelected() {
        // store filter word
        let filterWord = searchController.searchBar.text
        searchController.searchBar.text = listener?.onSwitchToSearch(filterWord: filterWord)
    }
    
    func filterSelected() {
        let searchWord = searchController.searchBar.text
        searchController.searchBar.text = listener?.onSwitchToFilter(searchWord: searchWord)
    }
    
    @objc
    func valueChanged(sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            searchSelected()
        default:
            filterSelected()
        }
    }

    private func setupViews() {
        let searchBar = searchController.searchBar
        
        containerView.addSubview(searchBar)

        view.addSubview(containerView)
        view.addSubview(collectionView)
        view.addSubview(suggestionsView)
        view.addSubview(segmentedControl)
        
        suggestionsView.listener = self
        segmentedControl.addTarget(self, action: #selector(valueChanged), for: .valueChanged)

        view.backgroundColor = .white

        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            containerView.leftAnchor.constraint(equalTo: view.leftAnchor),
            containerView.rightAnchor.constraint(equalTo: view.rightAnchor),
            containerView.heightAnchor.constraint(equalToConstant: 54)
        ])
        
        NSLayoutConstraint.activate([
            segmentedControl.topAnchor.constraint(equalTo: containerView.bottomAnchor),
            segmentedControl.leftAnchor.constraint(equalTo: view.leftAnchor),
            segmentedControl.rightAnchor.constraint(equalTo: view.rightAnchor),
            segmentedControl.heightAnchor.constraint(equalToConstant: Constants.CGFloats.suggestedCellHeight  - 8)
        ])
        
        NSLayoutConstraint.activate([
            suggestionsView.topAnchor.constraint(equalTo: segmentedControl.bottomAnchor, constant: 8),
            suggestionsView.bottomAnchor.constraint(equalTo: collectionView.topAnchor),
            suggestionsView.leftAnchor.constraint(equalTo: view.leftAnchor),
            suggestionsView.rightAnchor.constraint(equalTo: view.rightAnchor),
            suggestionsView.heightAnchor.constraint(equalToConstant: Constants.CGFloats.suggestedCellHeight)
        ])
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: suggestionsView.bottomAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            collectionView.leftAnchor.constraint(equalTo: view.leftAnchor),
            collectionView.rightAnchor.constraint(equalTo: view.rightAnchor)
        ])
        
        collectionView.dataSource = self
        collectionView.delegate = self

        searchController.searchResultsUpdater = self
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.obscuresBackgroundDuringPresentation = false
        
        searchBar.delegate = self
    }
}

extension RootViewController: SuggestionsViewListening {
    func searchWith(string: String) {
        if segmentedControl.selectedSegmentIndex != 0 {
            segmentedControl.selectedSegmentIndex = 0
        }
        listener?.onSearch(with: string)
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
    guard let string = searchController.searchBar.text, string != "" else { return }
    switch segmentedControl.selectedSegmentIndex {
    case 1:
        listener?.onFilter(filterWord: string)
        collectionView.reloadData()
    default:
        break
    }
  }
}

extension RootViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let string = searchBar.text, string != "" else { return }
        switch segmentedControl.selectedSegmentIndex {
        case 0:
            listener?.onSearch(with: string)
        default:
            break
        }
        
        searchController.isActive = false
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        
    }
}
