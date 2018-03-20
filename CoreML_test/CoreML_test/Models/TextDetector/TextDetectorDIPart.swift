//
//  TextDetectorDIPart.swift
//  CoreML_test
//
//  Created Осина П.М. on 19.02.18.
//  Copyright © 2018 Осина П.М.. All rights reserved.
//

import Foundation
import DITranquillity

class TextDetectorDIPart: DIPart {
    static func load(container: DIContainer) {
        container.register { () -> TextDetectorViewController in
            let storyboard = UIStoryboard(name: "TextDetector", bundle: nil)
            return storyboard.instantiateInitialViewController() as! TextDetectorViewController
            }
            .as(TextDetectorView.self)
            .injection(cycle: true) { $0.presenter = $1 }
            .lifetime(.objectGraph)
        
        container.register(TextDetectorPresenterImpl.init)
            .as(TextDetectorPresenter.self)
                
        container.register(TextDetectorRouterImpl.init)
            .as(TextDetectorRouter.self)
    }
}
