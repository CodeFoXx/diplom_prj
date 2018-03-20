//
//  HTTPURLResponseExtension.swift
//  CoreML_test
//
//  Created by owl on 18.03.18.
//  Copyright © 2018 Осина П.М. All rights reserved.
//

import Foundation

extension HTTPURLResponse {
    func isSuccessful() -> Bool{
        return 200 ..< 300 ~= statusCode
    }
}
