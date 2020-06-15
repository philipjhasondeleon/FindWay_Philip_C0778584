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
        

    }
    
}


