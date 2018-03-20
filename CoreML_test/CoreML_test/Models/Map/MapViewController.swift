//
//  MapViewController.swift
//  CoreML_test
//
//  Created Осина П.М. on 27.02.18.
//  Copyright © 2018 Осина П.М.. All rights reserved.
//

import UIKit
import MapKit

private struct Constants {
    static let activityAnnotationId = "activityAnnotationId"
    static let storylineSegmentAnnotationId = "storylineSegmentAnnotationId"
    static let horizontalRouteInset: CGFloat = 50
}

class MapViewController: UIViewController {

    @IBOutlet weak var mapView: MKMapView!
    var presenter: MapPresenter!
    
    private var routePolyline: RoutePolyline?
    private var activityAnotationView: ActivityAnnotationView?

	override func viewDidLoad() {
        super.viewDidLoad()
    }
    private func centerOnRoute(animated: Bool = true){
        var rect: MKMapRect = MKMapRectNull
        if let view = activityAnotationView{
            let region = mapView.convert(view)
        }
    }
}

extension MapViewController: MapView {
    
    
    private func annotationView(forActivityAnnotation annotation: ActivityAnnotation) -> MKAnnotationView{
        var annotationView: ActivityAnnotationView
        if let view = mapView.dequeueReusableAnnotationView(withIdentifier: Constants.activityAnnotationId) as? ActivityAnnotationView{
            annotationView = view
            annotationView.annotation = annotation
        }else{
            let activityAnnotationView = ActivityAnnotationView(annotation: annotation, reuseIdentifier: Constants.activityAnnotationId)
            activityAnnotationView.image = #imageLiteral(resourceName: "pin")
            activityAnnotationView.centerOffset = CGPoint(x: 0, y: -20)
            activityAnnotationView.delegate = self as! ActivityAnnotationViewDelegate
            annotationView = activityAnnotationView
        }
        activityAnotationView = annotationView
        return annotationView
        
    }
    
    
    private func annotationView(forStoryLineAnnotation annotation: StorylineSegmentAnnotation) -> MKAnnotationView{
        var annotationView: PlaceAnnotationView
        if let view = mapView.dequeueReusableAnnotationView(withIdentifier: Constants.storylineSegmentAnnotationId) as? PlaceAnnotationView{
            annotationView = view
            annotationView.annotation = annotation
        }else{
            annotationView = PlaceAnnotationView(annotation: annotation, reuseIdentifier: Constants.storylineSegmentAnnotationId)
            annotationView.canShowCallout = true
        }
        annotationView.image = #imageLiteral(resourceName: "map_circle")
        annotationView.foregroundImage = annotation.image
        return annotationView
    }
    
}


extension MapViewController: MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        if let polyline = overlay as? RoutePolyline{
            let lineView = MKPolylineRenderer(overlay: polyline)
            lineView.strokeColor = polyline.color
            lineView.lineWidth = 10
            return lineView
        }
        return MKOverlayRenderer()
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation)->MKAnnotationView?{
        var annotationView: MKAnnotationView?
        if let annotation = annotation as? ActivityAnnotation{
            annotationView = self.annotationView(forActivityAnnotation: annotation)
        }else if let annotation = annotation as? StorylineSegmentAnnotation{
            annotationView = self.annotationView(forStoryLineAnnotation: annotation)
            
        }
        return annotationView
    }
}
