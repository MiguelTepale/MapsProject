//
//  ViewController.swift
//  MapsProject
//
//  Created by Miguel Tepale on 5/10/17.
//  Copyright © 2017 Miguel Tepale. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit

class ViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate {
    
    let locationManager = CLLocationManager()
    let annotation = MKPointAnnotation()
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var tttImageView: UIImageView!
    @IBOutlet weak var mapSegmentedObject: UISegmentedControl!
    var initialRegionSet = false
    
    var counter = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapView.delegate = self
        locationManager.delegate = self
        
        annotation.coordinate = CLLocationCoordinate2D(latitude: 40.7084257, longitude: -74.0148711)
        
        locationManager.requestWhenInUseAuthorization()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        mapView.mapType = .standard
        mapView.showsUserLocation = true
        mapView.addAnnotation(annotation)
    }
    
    func mapViewDidFinishRenderingMap(_ mapView: MKMapView, fullyRendered: Bool) {
        if fullyRendered && !initialRegionSet {
                let viewRegion = MKCoordinateRegionMakeWithDistance(annotation.coordinate, 300.0, 300.0)
                mapView.setRegion(viewRegion, animated: true)
            initialRegionSet = true
        }
    }

    @IBAction func mapSegmentedAction(_ sender: UISegmentedControl) {
        switch (sender.selectedSegmentIndex) {
        case 0:
            mapView.mapType = .standard
        case 1:
            mapView.mapType = .satellite
        default:
            mapView.mapType = .hybrid
        }
    }
}
