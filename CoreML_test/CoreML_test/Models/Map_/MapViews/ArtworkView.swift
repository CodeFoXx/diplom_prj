//
//  ArtworkView.swift
//  htb
//
//  Created by Осина П.М. on 26.02.18.
//  Copyright © 2018 htb. All rights reserved.
//

import Foundation
import MapKit

@available(iOS 11.0, *)
class ArtworkMarkerView: MKMarkerAnnotationView{
    
    override var annotation: MKAnnotation?{
        willSet{
            guard let artwork = newValue as? Artwork else { return }
            canShowCallout = true
            calloutOffset = CGPoint(x: -10, y: 10)
            rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
            
            markerTintColor = artwork.markerTintColor
            glyphText = String(artwork.discipline.first!)
        }
    }
}
