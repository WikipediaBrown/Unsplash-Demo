//
//  DetailBuilder.swift
//  Unsplash-Demo
//
//  Created by Wikipedia Brown on 11/4/19.
//  Copyright © 2019 IamGoodBad. All rights reserved.
//

import RIBs

protocol DetailDependency: Dependency {
    var networkManager: NetworkManaging { get }
    var imageManager: ImageManaging { get }
    // TODO: Declare the set of dependencies required by this RIB, but cannot be
    // created by this RIB.
}

final class DetailComponent: Component<DetailDependency> {
    var networkManager: NetworkManaging { dependency.networkManager }
    var imageManager: ImageManaging { dependency.imageManager }
    // TODO: Declare 'fileprivate' dependencies that are only used by this RIB.
}

// MARK: - Builder

protocol DetailBuildable: Buildable {
    func build(withListener listener: DetailListener) -> DetailRouting
}

final class DetailBuilder: Builder<DetailDependency>, DetailBuildable {

    override init(dependency: DetailDependency) {
        super.init(dependency: dependency)
    }

    func build(withListener listener: DetailListener) -> DetailRouting {
        let component = DetailComponent(dependency: dependency)
        let viewController = DetailViewController()
        let interactor = DetailInteractor(presenter: viewController, networkManager: component.networkManager, imageManager: component.imageManager)
        interactor.listener = listener
        return DetailRouter(interactor: interactor, viewController: viewController)
    }
}
