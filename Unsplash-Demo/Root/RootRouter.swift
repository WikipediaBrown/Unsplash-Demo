//
//  RootRouter.swift
//  Unsplash-Demo
//
//  Created by Wikipedia Brown on 11/4/19.
//  Copyright © 2019 IamGoodBad. All rights reserved.
//

import RIBs

protocol RootInteractable: Interactable, DetailListener {
    var router: RootRouting? { get set }
    var listener: RootListener? { get set }
}

protocol RootViewControllable: ViewControllable {
    // TODO: Declare methods the router invokes to manipulate the view hierarchy.
}

final class RootRouter: LaunchRouter<RootInteractable, RootViewControllable>, RootRouting {
    
    var component: RootComponent

    // TODO: Constructor inject child builder protocols to allow building children.
    init(interactor: RootInteractable, viewController: RootViewControllable, component: RootComponent) {
        self.component = component
        super.init(interactor: interactor, viewController: viewController)
        interactor.router = self
    }
    
    func routeFromDetail() {

        for child in children {
            detachChild(child)
        }
    }
    
    func routeToDetail() {
        
        let detailRouter = DetailBuilder(dependency: component).build(withListener: interactor)
        let detailViewController = detailRouter.viewControllable.uiviewController
        
        attachChild(detailRouter)
        viewController.uiviewController.present(detailViewController, animated: true, completion: nil)
        
    }
}
