//
//  TranslationRouterImpl.swift
//  CoreML_test
//
//  Created Осина П.М. on 19.03.18.
//  Copyright © 2018 Осина П.М.. All rights reserved.
//

import UIKit
import DITranquillity

class TranslationRouterImpl: TranslationRouter {
    
    private weak var viewController: UIViewController?
    private let container: DIContainer!
    
    init(viewController: TranslationViewController, container: DIContainer) {
        self.viewController = viewController
        self.container = container
    }
    
    func navigateToTextDetectionView(){
        let textDetectionVC: TextDetectionViewController = *container
        let titleLabel = UILabel()
        titleLabel.text = "Text Detector"
        textDetectionVC.navigationItem.titleView = titleLabel
        viewController?.navigationController?.pushViewController(textDetectionVC, animated: true)
        viewController?.navigationController?.navigationBar.isHidden = false
        textDetectionVC.disableBackButtonTitle()
    }
}
