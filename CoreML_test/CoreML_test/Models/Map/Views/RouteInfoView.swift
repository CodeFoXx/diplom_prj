//
//  RouteInfoView.swift
//  CoreML_test
//
//  Created by Осина П.М. on 27.02.18.
//  Copyright © 2018 Осина П.М. All rights reserved.
//

import UIKit

class RouteInfoView: UIView {

    @IBOutlet private var startPlaceView: PlaceInfoView!
    @IBOutlet private var endPlaceView: PlaceInfoView!
    @IBOutlet private var routeView: UIView!
    
    func configure(){
        routeView.backgroundColor = .red
    }
}
