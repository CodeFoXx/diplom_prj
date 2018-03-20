//
//  ActivityAnnotationView.swift
//  CoreML_test
//
//  Created by Осина П.М. on 27.02.18.
//  Copyright © 2018 Осина П.М. All rights reserved.
//

import Foundation
import MapKit

private struct Constants {
    static let calloutAnimationDuration: TimeInterval = 0.25
}

protocol ActivityAnnotationViewDelegate: class {
    func activityAnnotationViewDidTapEdit(_ view: ActivityAnnotationView)
}

class ActivityAnnotationView: MKAnnotationView{
    
    weak var delegate: ActivityAnnotationViewDelegate?

    private weak var calloutView: ActivityCalloutView?
    var calloutViewFrame: CGRect {
        return calloutView?.frame ?? frame
    }
    
    
    override init(annotation: MKAnnotation?, reuseIdentifier: String?) {
        super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }
}
