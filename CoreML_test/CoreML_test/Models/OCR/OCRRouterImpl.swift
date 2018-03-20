//
//  OCRRouterImpl.swift
//  CoreML_test
//
//  Created Осина П.М. on 19.02.18.
//  Copyright © 2018 Осина П.М.. All rights reserved.
//

import UIKit
import DITranquillity

class OCRRouterImpl: OCRRouter {
    
    private weak var viewController: UIViewController?
    private let container: DIContainer!
    
    init(viewController: OCRViewController, container: DIContainer) {
        self.viewController = viewController
        self.container = container
    }
}
