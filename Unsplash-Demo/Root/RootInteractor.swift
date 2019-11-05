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
    // TODO: Declare methods the interactor can invoke to manage sub-tree via the router.
}

protocol RootPresentable: Presentable {
    var listener: RootPresentableListener? { get set }
    func updateData()
    func presentImage(image: UIImage, at index: Int)
    // TODO: Declare methods the interactor can invoke the presenter to present data.
}

protocol RootListener: class {
    // TODO: Declare methods the interactor can invoke to communicate with other RIBs.
}

final class RootInteractor: PresentableInteractor<RootPresentable>, RootInteractable, RootPresentableListener {

    weak var router: RootRouting?
    weak var listener: RootListener?
    
    var imageManager: ImageManaging?
    var networkManager: NetworkManaging?
    var images: [Image] = []
    var filteredImages: [Image] = []
    var currentPage: Int = 0
    
    private var query = "green"

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
        onSearch(query: query, page: currentPage)
    }

    override func willResignActive() {
        super.willResignActive()
        // TODO: Pause any business logic.
    }
    
    func onCountRequest() -> Int {
        return images.count
    }
    
    func onNextPage() {
        onSearch(query: query, page: currentPage)
    }
    
    func onRegularImageRequest(at index: Int) -> Image {
        
        let image = images[index]

        imageManager?.getImage(from: image.urls.thumb, at: index, completion: { [weak self] (result) in

            switch result {
            case .success(let uiImage):
                self?.images[uiImage.1].thumbnailImage = uiImage.0
                self?.presenter.presentImage(image: uiImage.0, at: uiImage.1)
            case .failure(let error):
                print(error)
            }
        })
                
        return image
    }
    
    func onFullImageRequest(at index: Int) -> Image {
        
        let image = images[index]
        
        imageManager?.getImage(from: image.urls.full, at: index, completion: { [weak self] (result) in
            
            switch result {
            case .success(let uiImage):
                self?.images[index].fullImage = uiImage.0
                self?.presenter.updateData()
            case .failure(let error):
                print(error)
            }
        })
                
        return image
        
    }
    
    func onSearch(query: String, page: Int) {

        networkManager?.get(from: page, query: query) { [weak self] result in
            switch result {
            case .success(let imagePage):
                self?.query = query
                self?.images.append(contentsOf: imagePage.results)
                self?.presenter.updateData()
            case .failure(let error):
                print(error)
            }
            
        }
        
        self.currentPage += 1
        
    }
    
    
}
