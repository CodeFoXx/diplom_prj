//
//  NetworkDIPart.swift
//  CoreML_test
//
//  Created by Осина П.М. on 19.02.18.
//  Copyright © 2018 Осина П.М. All rights reserved.
//

import Foundation
import DITranquillity
import Alamofire

fileprivate let endpointPath = "https://translate.yandex.net/api/v1.5/tr.json/"


class NetworkDIPart: DIPart {
    
    static func load(container: DIContainer) {
        container.register {try! TranslationProvider.init(endpointPath: endpointPath)}
            .lifetime(.single)
    }
}
