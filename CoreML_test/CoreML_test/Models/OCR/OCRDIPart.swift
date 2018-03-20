//
//  OCRDIPart.swift
//  CoreML_test
//
//  Created Осина П.М. on 19.02.18.
//  Copyright © 2018 Осина П.М.. All rights reserved.
//

import Foundation
import DITranquillity

class OCRDIPart: DIPart {
    static func load(container: DIContainer) {
        container.register { () -> OCRViewController in
            let storyboard = UIStoryboard(name: "OCR", bundle: nil)
            return storyboard.instantiateInitialViewController() as! OCRViewController
            }
            .as(OCRView.self)
            .injection(cycle: true) { $0.presenter = $1 }
            .lifetime(.objectGraph)
        
        container.register(OCRPresenterImpl.init)
            .as(OCRPresenter.self)
                
        container.register(OCRRouterImpl.init)
            .as(OCRRouter.self)
    }
}
