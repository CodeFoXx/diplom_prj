//
//  TextDetectorPresenterImpl.swift
//  CoreML_test
//
//  Created Осина П.М. on 19.02.18.
//  Copyright © 2018 Осина П.М.. All rights reserved.
//

import UIKit

class TextDetectorPresenterImpl: TextDetectorPresenter {

    weak private var view: TextDetectorView!
    private let router: TextDetectorRouter

    init(view: TextDetectorView, router: TextDetectorRouter) {
        self.view = view
        self.router = router
    }

}
