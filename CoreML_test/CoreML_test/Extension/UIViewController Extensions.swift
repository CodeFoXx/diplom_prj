//
//  UIViewController Extensions.swift
//  CoreML_test
//
//  Created by Осина П.М. on 05.03.18.
//  Copyright © 2018 Осина П.М. All rights reserved.
//

import Foundation
import UIKit
import SVProgressHUD

extension UIViewController {
    
    func showProgressHUD(){
        SVProgressHUD.show()
        self.view.isUserInteractionEnabled = false
    }
    
    func hideProgressHUD(){
        SVProgressHUD.dismiss()
        self.view.isUserInteractionEnabled = true
    }
    
    func showErrorMessage(message: String?){
        SVProgressHUD.showError(withStatus: message)
    }
    
    func disableBackButtonTitle(){
        navigationController?.navigationBar.topItem?.title = ""
    }
    
    func setNavigationTitle(text: String){
        let kerningLabel = UILabel()
        kerningLabel.text = text
        navigationItem.titleView = kerningLabel
        
    }
}
