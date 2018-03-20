//
//  TranslatedData.swift
//  CoreML_test
//
//  Created by Осина П.М. on 20.03.18.
//  Copyright © 2018 Осина П.М. All rights reserved.
//

import Foundation

struct TranslatedData: Codable{
    
    let code: Int
    let lang: String
    let text: [String]
    
    private enum CodingKeys: String, CodingKey {
        case code = "code"
        case lang = "lang"
        case text = "text"
    }
    
}
