//
//  AlertControllerFunctions.swift
//  CoreML_test
//
//  Created by owl on 10.03.18.
//  Copyright © 2018 Осина П.М. All rights reserved.
//

import Foundation
import UIKit

func createAlertController(title: String?, message: String) -> UIAlertController{
    return UIAlertController(title: title, message: message, preferredStyle: .alert)
}

func createActionSheet() -> UIAlertController{
    return UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
}

func createAction(title: String, style: UIAlertActionStyle, handler: ((UIAlertAction) -> Swift.Void)? = nil) -> UIAlertAction{
    return UIAlertAction(title: title, style: style, handler: handler)
}

func addActionsToAlertController(controller: UIAlertController, actions: [UIAlertAction]){
    for action in actions {
        controller.addAction(action)
    }
}
