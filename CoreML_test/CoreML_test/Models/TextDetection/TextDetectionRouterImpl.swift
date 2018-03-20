//
//  TextDetectionRouterImpl.swift
//  CoreML_test
//
//  Created Осина П.М. on 20.03.18.
//  Copyright © 2018 Осина П.М.. All rights reserved.
//

import UIKit
import DITranquillity

class TextDetectionRouterImpl: TextDetectionRouter {
    
    private weak var viewController: UIViewController?
    private let container: DIContainer!
    
    init(viewController: TextDetectionViewController, container: DIContainer) {
        self.viewController = viewController
        self.container = container
    }
}
