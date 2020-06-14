//
//  ViewController.swift
//  FindWay_ Philip_C0778584
//
//  Created by user175490 on 6/13/20.
//  Copyright © 2020 user175490. All rights reserved.
//

import UIKit
import MapKit

class ViewController: UIViewController, CLLocationManagerDelegate{

    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var btnGo: UIButton!
    var locatioManager = CLLocationManager()
       var source = CLLocationCoordinate2D()
       var destination = CLLocationCoordinate2D()
       var travelMode: String = "Drive"
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
           mapView.showsUserLocation = true
                //we give the delegate of location manager to this class
                locatioManager.delegate = self
                //desired accuracy of the location
                locatioManager.desiredAccuracy = kCLLocationAccuracyBest
                //request the user for the location access
                locatioManager.requestWhenInUseAuthorization()
                // start updating the location of the user
                locatioManager.startUpdatingLocation()
                // 1- define the latitude and longitude
                let latitude: CLLocationDegrees = 43.642567
                let longitude: CLLocationDegrees = -79.387054
                displayLocation(latitude: latitude, longitude: longitude, title: "I am here", subTitle: "Beautiful City")
                //long press gesture
                let uilpgr = UILongPressGestureRecognizer(target: self, action: #selector(addLongPressAnnotation))
                mapView.addGestureRecognizer(uilpgr)
        //        //double tap gesture

        //        let uidtgr = UITapGestureRecognizer(target: self, action: addDoubleTap())
    
        addDoubleTap()
        setRegion()

                    }
                    //MARK: add long press gesture recognizer for the annotation
                    @objc func addLongPressAnnotation(gestureRecognizer: UIGestureRecognizer) {
                        let touchPoint = gestureRecognizer.location(in: mapView)
                        let coordinate = mapView.convert(touchPoint, toCoordinateFrom: mapView)
                        //add annotation
                        let annotation = MKPointAnnotation()
                        annotation.title = "My Destination"
                        annotation.coordinate = coordinate
                        mapView.addAnnotation(annotation)
                    }
                    func addDoubleTap() {
                        let doubleTap = UITapGestureRecognizer(target: self, action: #selector(dropPin))
                        doubleTap.numberOfTapsRequired = 2
                        mapView.addGestureRecognizer(doubleTap)
                    }
                    @objc func dropPin(sender: UITapGestureRecognizer){
                        removePin()
                        let touchPoint = sender.location(in: mapView)
                        let coordinate = mapView.convert(touchPoint, toCoordinateFrom: mapView)
                        //add annotation
                        let annotation = MKPointAnnotation()
                        annotation.title = "My Destination"
                        annotation.coordinate = coordinate
                        mapView.addAnnotation(annotation)
                        destination = mapView.convert(touchPoint, toCoordinateFrom: mapView)
                        
                    }
                     func setRegion() {
                           // define latitude and longitude for CN Tower toronto
                           let latitude: CLLocationDegrees = 43.642567
                           let longitude: CLLocationDegrees = -79.387054
                           let latDelta: CLLocationDegrees = 0.5
                           let longDelta: CLLocationDegrees = 0.5
                           let span = MKCoordinateSpan(latitudeDelta: latDelta, longitudeDelta: longDelta)
                           let location = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
                           let region = MKCoordinateRegion(center: location, span: span)
                           mapView.setRegion(region, animated: true)
                            mapView.delegate = self

                       }    //MARK: didUpdateLocation method
                    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
                        let userLocation = locations[0]
                        let latitude = userLocation.coordinate.latitude
                        let longitude = userLocation.coordinate.longitude
                        displayLocation(latitude: latitude, longitude: longitude, title: "Your Location", subTitle: "You are here")
                    }
                    //MARK: display user location method

                    func displayLocation(latitude: CLLocationDegrees, longitude: CLLocationDegrees, title: String, subTitle: String) {
                        let latDelta: CLLocationDegrees = 0.05
                        let lngDelta: CLLocationDegrees = 0.05
                        let span = MKCoordinateSpan(latitudeDelta: latDelta, longitudeDelta: lngDelta)
                        let location = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
                        // set region for the map
                        let region = MKCoordinateRegion(center: location, span: span)
                        mapView.setRegion(region, animated: true)
                        //add annotation
                        let annotation = MKPointAnnotation()
                        annotation.coordinate = location
                        annotation.title = "Toronto Downtown"
                        annotation.subtitle = "Beautiful City"
                        mapView.addAnnotation(annotation)

                    }
                    func removePin()
                    {
                        for annotation in mapView.annotations {
                            mapView.removeAnnotation(annotation)
                        }
                    }
                    
                    @IBAction func btnClickgo(_ sender: UIButton) {
                          let overlays = mapView.overlays
                                mapView.removeOverlays(overlays)
                                
                                // draw route
                                let request = MKDirections.Request()
                                request.source = MKMapItem(placemark: MKPlacemark(coordinate: source, addressDictionary: nil))
                                request.destination = MKMapItem(placemark: MKPlacemark(coordinate: destination, addressDictionary: nil))
                                request.requestsAlternateRoutes = true
                                if(travelMode == "D"){
                                    request.transportType = .automobile
                                }
                                else{
                                    
                                    request.transportType = .walking
                                }
                                
                                let directions = MKDirections(request: request)
                                directions.calculate { [unowned self] response, error in
                                    guard let unwrappedResponse = response else { return }
                                    let route = unwrappedResponse.routes[0]
                                    self.mapView.addOverlay(route.polyline)
                                    self.mapView.setVisibleMapRect(route.polyline.boundingMapRect, animated: true)
                                    }
                    }
                    
                }
                extension ViewController: MKMapViewDelegate {
                    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
                        if annotation is MKUserLocation {
                            return nil
                        }
                        let pinAnnotation = MKPinAnnotationView(annotation: annotation, reuseIdentifier: "droppablePin")
                        pinAnnotation.animatesDrop = true
                        return pinAnnotation
                    }

                func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
                    if overlay is MKCircle {
                        let renderer = MKCircleRenderer(overlay: overlay)
                        renderer.fillColor = UIColor.black.withAlphaComponent(0.5)
                        renderer.strokeColor = UIColor.green
                        renderer.lineWidth = 2.0
                        return renderer
                    } else if overlay is MKPolyline {
                        let renderer = MKPolylineRenderer(overlay: overlay)
                        renderer.strokeColor = UIColor.green
                        renderer.lineWidth = 3.0
                        return renderer
                    } else if overlay is MKPolygon {
                        let renderer = MKPolygonRenderer(overlay: overlay)
                        renderer.fillColor = UIColor.black.withAlphaComponent(0.5)
                        renderer.strokeColor = UIColor.orange
                        renderer.lineWidth = 2.0
                        return renderer
                    }
                    
                    return MKOverlayRenderer()
                    
                }

                }



