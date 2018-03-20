//
//  MainRouterImpl.swift
//  CoreML_test
//
//  Created Осина П.М. on 19.02.18.
//  Copyright © 2018 Осина П.М.. All rights reserved.
//

import UIKit
import DITranquillity

class MainRouterImpl: MainRouter {
    
    private weak var viewController: UIViewController?
    private let container: DIContainer!
    
    init(viewController: MainViewController, container: DIContainer) {
        self.viewController = viewController
        self.container = container
    }
    
    func navigateToTextDetectorView(){
        let textDetectionVC: OCRViewController = *container
        let titleLabel = UILabel()
        titleLabel.text = "TXT"
        textDetectionVC.navigationItem.titleView = titleLabel
        viewController?.navigationController?.pushViewController(textDetectionVC, animated: true)
        textDetectionVC.disableBackButtonTitle()
    }
}
