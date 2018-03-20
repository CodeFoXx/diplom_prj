//
//  MapPresenterImpl.swift
//  htb
//
//  Created Осина П.М. on 26.02.18.
//  Copyright © 2018 htb. All rights reserved.
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
