//
//  ApiError.swift
//  CoreML_test
//
//  Created by owl on 18.03.18.
//  Copyright © 2018 Осина П.М. All rights reserved.
//

import Foundation
import ObjectMapper

struct ApiError: Mappable {

    var code: Int?
    var message: String!

    init?(map: Map) {

    }

    mutating func mapping(map: Map) {
        message     <- map["error"]
    }
}

//struct ApiError: Codable {
//    
//    let message: String
//    
//    init(message: String? = ""){
//        self.message = message!
//        
//    }
//    
//    private enum CodingKeys: String, CodingKey {
//        case message = "message"
//    }
//    
//    
//}

