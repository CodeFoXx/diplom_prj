//
//  TranslationContract.swift
//  CoreML_test
//
//  Created Осина П.М. on 19.03.18.
//  Copyright © 2018 Осина П.М.. All rights reserved.
//

import Foundation

protocol TranslationView: class {
    
}

protocol TranslationPresenter {
    func translationRequest(language: String, text: String)
}

protocol TranslationRouter {

}
