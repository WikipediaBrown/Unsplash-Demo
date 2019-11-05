//
//  RootInteractor.swift
//  Unsplash-Demo
//
//  Created by Wikipedia Brown on 11/4/19.
//  Copyright © 2019 IamGoodBad. All rights reserved.
//

import RIBs
import RxSwift

protocol RootRouting: ViewableRouting {
    func routeFromDetail()
    func routeToDetail()
    // TODO: Declare methods the interactor can invoke to manage sub-tree via the router.
}

protocol RootPresentable: Presentable {
    var listener: RootPresentableListener? { get set }
    func updateData()
    func presentImage(image: UIImage, at index: Int)
    func updateHistory(with history: [String?])
    // TODO: Declare methods the interactor can invoke the presenter to present data.
}

protocol RootListener: class {
    // TODO: Declare methods the interactor can invoke to communicate with other RIBs.
}

final class RootInteractor: PresentableInteractor<RootPresentable>, RootInteractable, RootPresentableListener {

    weak var router: RootRouting?
    weak var listener: RootListener?
    
    private var currentPage: Int = 0
    private var currentImages: [Image]?
    private var images: [Image] = []
    private var imageManager: ImageManaging?
    private var networkManager: NetworkManaging?
    private var searchQueries: Queue<String> = Queue<String>()
    private var commonQueries = ["Green", "Mountains", "Blue", "Mom", "Grand", "Fun", "Great", "Grey", "Sand", "beach", "forrest", "intern", "gloves", "Parka", "sword", ]
    private var query = "green"
    private var filter = ""
    private var isFiltering = false

    // TODO: Add additional dependencies to constructor. Do not perform any logic
    // in constructor.
    init(presenter: RootPresentable, networkManager: NetworkManaging, imageManager: ImageManaging) {
        self.networkManager = networkManager
        self.imageManager = imageManager
        super.init(presenter: presenter)
        presenter.listener = self
    }

    override func didBecomeActive() {
        super.didBecomeActive()
        getPageWith(query: query, page: currentPage)
    }

    override func willResignActive() {
        super.willResignActive()
        // TODO: Pause any business logic.
    }
    
    func onCountRequest() -> Int {
        return currentImages?.count ?? images.count
    }
    
    func onNextPage() {
        getPageWith(query: query, page: currentPage)
    }
    
    func onRegularImageRequest(at index: Int) -> Image {
        let image = images[index]

        imageManager?.getImage(from: image.urls.thumb, at: index, completion: { [weak self] (result) in
            switch result {
            case .success(let uiImage):
                self?.images[uiImage.1].thumbnailImage = uiImage.0
                self?.presenter.updateData()
//                self?.presenter.presentImage(image: uiImage.0, at: uiImage.1)
            case .failure(let error):
                print(error)
            }
        })
                
        return image
    }
    
    func onSearch(with query: String) {
        var duplicate = false
        for searchString in searchQueries.allElements {
            if searchString == query { duplicate = true; break}
        }
        
        if !duplicate {
            if searchQueries.count >= 5 { let _ = searchQueries.dequeue() }
            searchQueries.enqueue(query)
            presenter.updateHistory(with: searchQueries.allElements)
        }
        
        currentPage = 0
        currentImages = nil
        images = []
        getPageWith(query: query, page: currentPage)
        
    }
    
    func onSelect(at index: Int) {
        imageManager?.selectedImage = currentImages?[index] ?? images[index]
        router?.routeToDetail()
    }
    
    func onDismiss() {
        imageManager?.selectedImage = nil
        router?.routeFromDetail()
    }
    
    func onSwitchToSearch(filterWord: String?) -> String {
        currentImages = images
        filter = filterWord ?? ""
        isFiltering = false
        presenter.updateData()
        return query
    }
    
    func onSwitchToFilter(searchWord: String?) -> String {
        query = searchWord ?? ""
        isFiltering = true
        if filter != "" {
            currentImages = images.filter {($0.alt_description?.contains(filter) ?? false)}
        } else {
            currentImages = images
        }
        presenter.updateData()
        return filter
    }
    
    func onFilter(filterWord: String) {
        if filterWord != "" {
            currentImages = images.filter {($0.alt_description?.lowercased().contains(filterWord.lowercased()) ?? false)}
        } else {
            currentImages = images
        }
        filter = filterWord
    }
    
    private func getPageWith(query: String, page: Int) {

        networkManager?.get(from: page, query: query) { [weak self] result in
            switch result {
            case .success(let imagePage):
                self?.query = query
                self?.images.append(contentsOf: imagePage.results)
                if self?.isFiltering ?? false {
                    self?.onFilter(filterWord: self?.filter ?? "")
                }
                self?.presenter.updateData()
            case .failure(let error):
                print(error)
            }
        }
        
        currentPage += 1
        
    }
    
}
