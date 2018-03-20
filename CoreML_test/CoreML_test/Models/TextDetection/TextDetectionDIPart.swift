//
//  TextDetectionDIPart.swift
//  CoreML_test
//
//  Created Осина П.М. on 20.03.18.
//  Copyright © 2018 Осина П.М.. All rights reserved.
//

import Foundation
import DITranquillity

class TextDetectionDIPart: DIPart {
    static func load(container: DIContainer) {
        container.register { () -> TextDetectionViewController in
            let storyboard = UIStoryboard(name: "TextDetection", bundle: nil)
            return storyboard.instantiateInitialViewController() as! TextDetectionViewController
            }
            .as(TextDetectionView.self)
            .injection(cycle: true) { $0.presenter = $1 }
            .lifetime(.objectGraph)
        
        container.register(TextDetectionPresenterImpl.init)
            .as(TextDetectionPresenter.self)
                
        container.register(TextDetectionRouterImpl.init)
            .as(TextDetectionRouter.self)
    }
}
