//
//  OCRPresenterImpl.swift
//  CoreML_test
//
//  Created Осина П.М. on 19.02.18.
//  Copyright © 2018 Осина П.М.. All rights reserved.
//

import UIKit

class OCRPresenterImpl: OCRPresenter {

    weak private var view: OCRView!
    private let router: OCRRouter

    init(view: OCRView, router: OCRRouter) {
        self.view = view
        self.router = router
    }

}
