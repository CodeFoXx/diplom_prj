//
//  ActivityAnnotation.swift
//  CoreML_test
//
//  Created by Осина П.М. on 27.02.18.
//  Copyright © 2018 Осина П.М. All rights reserved.
//

import Foundation
import MapKit

class ActivityAnnotation: NSObject, MKAnnotation {
    
    var title: String?{
        return "tittle"
    }
    
    var transportIcon: UIImage?{
        return #imageLiteral(resourceName: "subway")
    }
    
    var subtitle: String?{
        return "partner"
    }
    
    var isSelected: Bool?{
        return true
    }
    let coordinate: CLLocationCoordinate2D

    init(coordinate: CLLocationCoordinate2D) {
        self.coordinate = coordinate
        super.init()
    }
}
