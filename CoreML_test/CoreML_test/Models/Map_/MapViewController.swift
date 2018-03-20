//
//  MapViewController.swift
//  htb
//
//  Created Осина П.М. on 26.02.18.
//  Copyright © 2018 htb. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController {

    @IBOutlet weak var mapView: MKMapView!
    var presenter: MapPresenter!
    
    let regionRadius: CLLocationDistance = 1000
    var artWorks: [Artwork] = []
    let locationManager = CLLocationManager()
    var previousAnnotation = MKPointAnnotation()


    @IBAction func pinPress(_ sender: UILongPressGestureRecognizer) {
    
        let location = sender.location(in: mapView)
        let locCord = self.mapView.convert(location, toCoordinateFrom: self.mapView)
        
        let annotation = MKPointAnnotation()
        annotation.coordinate = locCord
        annotation.title = "Store"
        annotation.subtitle = "Location of Store"
        
        let c = mapView.annotations.count-1
        let prevAnnotation = mapView.annotations[c]
        
//        if self.mapView.annotations.count > 2 {
//            self.mapView.removeAnnotations(mapView.annotations)
//            self.mapView.removeOverlays(mapView.overlays)
//        }
        
        self.mapView.removeAnnotations(mapView.annotations)
        self.mapView.removeOverlays(mapView.overlays)
        
        let c1 = mapView.annotations.count-1
        
        if (previousAnnotation.title != "null"){
            self.mapView.addAnnotation(previousAnnotation)
            self.mapView.addAnnotation(annotation)
            let count = self.mapView.annotations.count
            //Draw route between 2 points
            if self.mapView.annotations.count == 2{
                drawRoute(sourceLocation: prevAnnotation.coordinate, destinationLocation: annotation.coordinate)
                
            }
        }else{
            self.mapView.addAnnotation(prevAnnotation)
            previousAnnotation.title = "source"
            self.mapView.addAnnotation(annotation)
            let count = self.mapView.annotations.count
            //Draw route between 2 points
            if self.mapView.annotations.count == 2{
                drawRoute(sourceLocation: prevAnnotation.coordinate, destinationLocation: annotation.coordinate)
                
            }
        }
        
        previousAnnotation = annotation
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        previousAnnotation.title = "null"
        
        
        let location = CLLocation(latitude: 21.282778, longitude: -157.829444)
        centerMapOnLocation(location: location)
        
        mapView.delegate = self
        let location2D = CLLocationCoordinate2D(latitude: 21.282778, longitude: -157.829444)
        
        //let region = MKCoordinateRegion(center: location, span: span)
        
        
        //let bigBen = Artwork(title: "King David Kalakaua", locationName: "Waikiki Gateway Park", discipline: "Sculpture", coordinate: location2D)
        
        mapView.isZoomEnabled = true
        if #available(iOS 11.0, *) {
            mapView.register(ArtworkMarkerView.self, forAnnotationViewWithReuseIdentifier: MKMapViewDefaultAnnotationViewReuseIdentifier)
        } else {
            // Fallback on earlier versions
        }
        locationManager.requestWhenInUseAuthorization()

        if CLLocationManager.locationServicesEnabled(){
            locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
            //locationManager.requestLocation()
        }
        loadInitialData()
        mapView.addAnnotations(artWorks)
        
    }
    
    func loadInitialData(){
        guard let fileName = Bundle.main.path(forResource: "PublicArt", ofType: "json")
            else { return }
        let optionalData = try? Data(contentsOf: URL(fileURLWithPath: fileName))
        
        guard
            let data = optionalData,
            let json = try? JSONSerialization.jsonObject(with: data),
            let dictionary = json as? [String: Any],
            let works = dictionary["data"] as? [[Any]]
            else { return }
        
        let validWorks = works.flatMap{ Artwork(json: $0)}
        artWorks.append(contentsOf: validWorks)
    }
    
    func centerMapOnLocation(location: CLLocation){
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate, regionRadius, regionRadius)
        mapView.setRegion(coordinateRegion, animated: true)
    }
    
    func drawRoute(sourceLocation: CLLocationCoordinate2D, destinationLocation: CLLocationCoordinate2D){
        
        //let sourceLocation = CLLocationCoordinate2D(latitude: 40.759011, longitude: -73.984472)
        //let destinationLocation = CLLocationCoordinate2D(latitude: 40.748441, longitude: -73.98556)
        
        let sourcePlacemark = MKPlacemark(coordinate: sourceLocation, addressDictionary: nil)
        let destinationPlacemark = MKPlacemark(coordinate: destinationLocation, addressDictionary: nil)
        
        let sourceMapItem = MKMapItem(placemark: sourcePlacemark)
        let destinationMapItem = MKMapItem(placemark: destinationPlacemark)
        
        let sourceAnnotation = MKPointAnnotation()
        sourceAnnotation.title = "Times Square"
        
        if let location = sourcePlacemark.location{
            sourceAnnotation.coordinate = location.coordinate
        }
        
        let destinationAnnotation = MKPointAnnotation()
        destinationAnnotation.title = "Empire State Building"
        
        if let location = destinationPlacemark.location{
            destinationAnnotation.coordinate = location.coordinate
        }
        
        self.mapView.showAnnotations([sourceAnnotation, destinationAnnotation], animated: true)
        
        let directionRequest = MKDirectionsRequest()
        directionRequest.source = sourceMapItem
        directionRequest.destination = destinationMapItem
        directionRequest.transportType = .automobile
        
        
        let directions = MKDirections(request: directionRequest)
        
        directions.calculate{
            (response, error) -> Void in
            guard let response = response else{
                if let error = error{
                    print("Error: \(error)")
                }
                return
            }
            let route = response.routes[0]
            self.mapView.add((route.polyline), level: MKOverlayLevel.aboveRoads)
            
            
            let rect = route.polyline.boundingMapRect
            self.mapView.setRegion(MKCoordinateRegionForMapRect(rect), animated: true)
        }
    }
    
}

extension MapViewController: MapView, MKMapViewDelegate {
    
//    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
//        
//        guard let annotaion = annotation as? Artwork else { return nil }
//        
//        let identifier = "marker"
//        if #available(iOS 11.0, *) {
//            var view: MKMarkerAnnotationView
//            if let daqueuedView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)
//                as? MKMarkerAnnotationView{
//                daqueuedView.annotation = annotation
//                view = daqueuedView
//            }
//            else{
//                view = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: identifier)
//                view.canShowCallout = true
//                view.calloutOffset = CGPoint(x: -5, y: 5)
//                view.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
//            }
//            return view
//        } else {
//            // Fallback on earlier versions
//            return nil
//        }
//    }
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        let location = view.annotation as! Artwork
        let launchOptions = [MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving]
        location.mapItem().openInMaps(launchOptions: launchOptions)
    }
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let renderer = MKPolylineRenderer(polyline: overlay as! MKPolyline)
        renderer.strokeColor = UIColor.red
        renderer.lineWidth = 2
        return renderer
    }
}
