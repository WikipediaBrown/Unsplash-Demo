//
//  DetailInteractor.swift
//  Unsplash-Demo
//
//  Created by Wikipedia Brown on 11/4/19.
//  Copyright © 2019 IamGoodBad. All rights reserved.
//

import RIBs

protocol DetailRouting: ViewableRouting {
    // TODO: Declare methods the interactor can invoke to manage sub-tree via the router.
}

protocol DetailPresentable: Presentable {
    var listener: DetailPresentableListener? { get set }
    func setData(image: Image)
    func setImage(image: UIImage)
    // TODO: Declare methods the interactor can invoke the presenter to present data.
}

protocol DetailListener: class {
    func onDismiss()
    // TODO: Declare methods the interactor can invoke to communicate with other RIBs.
}

final class DetailInteractor: PresentableInteractor<DetailPresentable>, DetailInteractable, DetailPresentableListener {

    weak var router: DetailRouting?
    weak var listener: DetailListener?
    
    var imageManager: ImageManaging?
    var networkManager: NetworkManaging?
    
    // TODO: Add additional dependencies to constructor. Do not perform any logic
    // in constructor.
    init(presenter: DetailPresentable, networkManager: NetworkManaging, imageManager: ImageManaging) {
        self.networkManager = networkManager
        self.imageManager = imageManager
        super.init(presenter: presenter)
        presenter.listener = self
    }

    override func didBecomeActive() {
        super.didBecomeActive()
        setData(image: imageManager?.selectedImage)
        // TODO: Implement business logic here.
    }

    override func willResignActive() {
        super.willResignActive()
        // TODO: Pause any business logic.
    }
    
    func onDismiss() {
        listener?.onDismiss()
    }
    
    private func setData(image: Image?) {
        guard let image = image else { return }
        presenter.setData(image: image)
        setImage(image: image)
    }
    
    private func setImage(image: Image) {
        
        imageManager?.getImage(from: image.urls.full, at: 0, completion: { [weak self] (result) in
            switch result {
            case .success(let uiImage):
                self?.presenter.setImage(image: uiImage.0)
            case .failure(let error):
                print(error)
            }
        })
        
    }
    
}
