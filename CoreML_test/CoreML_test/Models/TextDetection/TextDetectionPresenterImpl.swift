//
//  TextDetectionPresenterImpl.swift
//  CoreML_test
//
//  Created Осина П.М. on 20.03.18.
//  Copyright © 2018 Осина П.М.. All rights reserved.
//

import UIKit

class TextDetectionPresenterImpl: TextDetectionPresenter {

    weak private var view: TextDetectionView!
    private let router: TextDetectionRouter

    init(view: TextDetectionView, router: TextDetectionRouter) {
        self.view = view
        self.router = router
    }

}
