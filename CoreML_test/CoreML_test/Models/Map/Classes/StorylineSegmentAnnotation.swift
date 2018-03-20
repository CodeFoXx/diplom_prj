//
//  StorylineSegmentAnnotation.swift
//  CoreML_test
//
//  Created by Осина П.М. on 27.02.18.
//  Copyright © 2018 Осина П.М. All rights reserved.
//

import Foundation
import MapKit

class StorylineSegmentAnnotation: NSObject, MKAnnotation{
    
    var title: String?{
        return "title"
    }
    var subtitle: String?{
        return nil
    }
    var image : UIImage?{
        return #imageLiteral(resourceName: "subway")
    }
    let coordinate: CLLocationCoordinate2D
    
    init(coordinate: CLLocationCoordinate2D) {
        self.coordinate = coordinate
        
        super.init()
    }
    
}
