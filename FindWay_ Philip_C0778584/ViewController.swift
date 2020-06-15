//
//  ViewController.swift
//  FindWay_ Philip_C0778584
//
//  Created by user175490 on 6/13/20.
//  Copyright © 2020 user175490. All rights reserved.
//

import UIKit
import MapKit

class ViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {

    @IBOutlet weak var btnFindWay: UIButton!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var segmentType: UISegmentedControl!
    
    var locationManager = CLLocationManager()
    
    var aLat: CLLocationDegrees??
    var aLon: CLLocationDegrees??
    var location: CLLocation?
    
  
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapView.delegate = self
        locationManager.delegate = self
       
        locationManager.requestWhenInUseAuthorization()
        
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.distanceFilter = kCLDistanceFilterNone
        
        locationManager.startUpdatingLocation()
        
        mapView.showsUserLocation = true
        mapView.isZoomEnabled = false
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(doubleTapped))
        tap.numberOfTapsRequired = 2
        mapView.addGestureRecognizer(tap)
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]){
            
            location = locations.first!
            let coordinateRegion = MKCoordinateRegion(center: location!.coordinate, latitudinalMeters: 1000, longitudinalMeters:1000)
        mapView.setRegion(coordinateRegion, animated: true)
            locationManager.stopUpdatingLocation()
        }
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let renderer = MKPolylineRenderer(polyline: overlay as! MKPolyline)
        renderer.strokeColor = UIColor.yellow
        renderer.lineWidth = 3;
        return renderer
    }
    
    @objc func doubleTapped(sender: UIGestureRecognizer){
           
            let locationInView = sender.location(in: mapView)
            let locationOnMap = mapView.convert(locationInView, toCoordinateFrom: mapView)
            addAnnotation(location: locationOnMap)
        
    }
    
 
    
    
     func addAnnotation(location: CLLocationCoordinate2D)
        {
           
            let oldAnnotations = self.mapView.annotations
            self.mapView.removeAnnotations(oldAnnotations)
            let annotation = MKPointAnnotation()
            annotation.coordinate = location
            aLat = annotation.coordinate.latitude
            aLon = annotation.coordinate.longitude
            annotation.title = "Destination"
            annotation.subtitle = "Here is your place"
            self.mapView.addAnnotation(annotation)
        }
}


