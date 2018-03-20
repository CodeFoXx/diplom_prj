//
//  AppDIPart.swift
//  CoreML_test
//
//  Created by Осина П.М. on 19.02.18.
//  Copyright © 2018 Осина П.М. All rights reserved.
//

import Foundation
import DITranquillity

private typealias RootContainer = DIContainer

class AppDIPart: DIPart {
    
    static func load(container: DIContainer) {
        container.register { UserDefaults.standard }
            .lifetime(.weakSingle)
//        container.register { (UIApplication.shared.delegate as! AppDelegate).container }
//            .as(RootContainer.self)
    }
}
