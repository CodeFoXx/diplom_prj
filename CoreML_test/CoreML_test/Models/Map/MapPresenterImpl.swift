//
//  MapPresenterImpl.swift
//  CoreML_test
//
//  Created Осина П.М. on 27.02.18.
//  Copyright © 2018 Осина П.М.. All rights reserved.
//

import UIKit

class MapPresenterImpl: MapPresenter {

    weak private var view: MapView!
    private let router: MapRouter

    init(view: MapView, router: MapRouter) {
        self.view = view
        self.router = router
    }

}
