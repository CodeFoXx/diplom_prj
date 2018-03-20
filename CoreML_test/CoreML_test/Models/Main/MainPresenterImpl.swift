//
//  MainPresenterImpl.swift
//  CoreML_test
//
//  Created Осина П.М. on 19.02.18.
//  Copyright © 2018 Осина П.М.. All rights reserved.
//

import UIKit

class MainPresenterImpl: MainPresenter {

    weak private var view: MainView!
    private let router: MainRouter

    init(view: MainView, router: MainRouter) {
        self.view = view
        self.router = router
    }
    
    func navigateToTextDetectorView(){
        router.navigateToTextDetectorView()
    }

}
