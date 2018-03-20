//
//  TranslationDIPart.swift
//  CoreML_test
//
//  Created Осина П.М. on 19.03.18.
//  Copyright © 2018 Осина П.М.. All rights reserved.
//

import Foundation
import DITranquillity

class TranslationDIPart: DIPart {
    static func load(container: DIContainer) {
        container.register { () -> TranslationViewController in
            let storyboard = UIStoryboard(name: "Translation", bundle: nil)
            return storyboard.instantiateInitialViewController() as! TranslationViewController
            }
            .as(TranslationView.self)
            .injection(cycle: true) { $0.presenter = $1 }
            .lifetime(.objectGraph)
        
        container.register(TranslationPresenterImpl.init(view:router:translationService:))
            .as(TranslationPresenter.self)
                
        container.register(TranslationRouterImpl.init)
            .as(TranslationRouter.self)
    }
}
