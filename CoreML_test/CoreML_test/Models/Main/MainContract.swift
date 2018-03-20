//
//  MainContract.swift
//  CoreML_test
//
//  Created Осина П.М. on 19.02.18.
//  Copyright © 2018 Осина П.М.. All rights reserved.
//

import Foundation

protocol MainView: class {
    
}

protocol MainPresenter {
    func navigateToTextDetectorView()
}

protocol MainRouter {
    func navigateToTextDetectorView()
}
