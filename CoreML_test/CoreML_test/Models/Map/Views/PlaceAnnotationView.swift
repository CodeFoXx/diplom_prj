//
//  PlaceAnnotationView.swift
//  CoreML_test
//
//  Created by Осина П.М. on 27.02.18.
//  Copyright © 2018 Осина П.М. All rights reserved.
//

import Foundation
import UIKit
import MapKit.MKAnnotationView

class PlaceAnnotationView: MKAnnotationView{
    
    private let  foregroundImageView = UIImageView()
    var foregroundImage: UIImage?{
        didSet{
            foregroundImageView.image = foregroundImage
        }
    }
    
    override init(annotation: MKAnnotation?, reuseIdentifier reuseIdentifer: String?){
        super.init(annotation: annotation, reuseIdentifier: reuseIdentifer)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    private func setup(){
        foregroundImageView.translatesAutoresizingMaskIntoConstraints = false
        foregroundImageView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        foregroundImageView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        foregroundImageView.leadingAnchor.constraint(greaterThanOrEqualTo: leadingAnchor).isActive = true
        foregroundImageView.trailingAnchor.constraint(lessThanOrEqualTo: trailingAnchor).isActive = true
        foregroundImageView.topAnchor.constraint(greaterThanOrEqualTo: topAnchor).isActive = true
        foregroundImageView.bottomAnchor.constraint(lessThanOrEqualTo: bottomAnchor).isActive = true
        
        
        
    }
    
}
