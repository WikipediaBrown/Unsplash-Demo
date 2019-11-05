//
//  AppComponent.swift
//  Unsplash-Demo
//
//  Created by Wikipedia Brown on 11/4/19.
//  Copyright © 2019 IamGoodBad. All rights reserved.
//

import RIBs

class AppComponent: Component<EmptyDependency>, RootDependency {
            
    init() {
        super.init(dependency: EmptyComponent())
    }
}
