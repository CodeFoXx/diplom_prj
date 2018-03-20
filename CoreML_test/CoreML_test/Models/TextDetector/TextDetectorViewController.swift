//
//  TextDetectorViewController.swift
//  CoreML_test
//
//  Created Осина П.М. on 19.02.18.
//  Copyright © 2018 Осина П.М.. All rights reserved.
//

import UIKit

class TextDetectorViewController: UIViewController {

	var presenter: TextDetectorPresenter!

	override func viewDidLoad() {
        super.viewDidLoad()
    }
}

extension TextDetectorViewController: TextDetectorView {
    
}
