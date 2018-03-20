//
//  TranslationApiError.swift
//  CoreML_test
//
//  Created by owl on 18.03.18.
//  Copyright © 2018 Осина П.М. All rights reserved.
//

import Foundation

enum TranslationApiError: Error {
    
    case apiError(ApiError)
    case illegalArgument(String)
    case generic(Int, String)
    
    func description() -> String {
        switch self {
        case .apiError(let apiError): return apiError.message
        case .illegalArgument(let message): return message
        case .generic(_, let message): return message
        }
    }
    
    func code() -> Int {
        switch self {
        case .generic(let code, _):
            return code
        default:
            return -1
        }
    }
}

