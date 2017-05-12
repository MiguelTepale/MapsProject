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
    var bars: [Bar] = []
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var tttImageView: UIImageView!
    @IBOutlet weak var mapSegmentedObject: UISegmentedControl!
    var initialRegionSet = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadLocalBars()
        
        mapView.delegate = self
        locationManager.delegate = self
        
        annotation.coordinate = CLLocationCoordinate2D(latitude: 40.7084257, longitude: -74.0148711)
        
        locationManager.requestWhenInUseAuthorization()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        
        mapView.mapType = .standard
        mapView.showsUserLocation = true
        mapView.addAnnotation(annotation)
        mapView.addAnnotations(bars)
        
    }
    
    func mapViewDidFinishRenderingMap(_ mapView: MKMapView, fullyRendered: Bool) {
        if fullyRendered && !initialRegionSet {
            let viewRegion = MKCoordinateRegionMakeWithDistance(annotation.coordinate, 700.0, 700.0)
            mapView.setRegion(viewRegion, animated: true)
            initialRegionSet = true
        }
    }
    
    func loadLocalBars() {
        guard let plistUrl = Bundle.main.url(forResource: "BarList", withExtension: "plist"), let pListData = NSData(contentsOf: plistUrl) else { return }
        var format = PropertyListSerialization.PropertyListFormat.xml
        var barEntries: NSArray!
        
        do {
            barEntries = try PropertyListSerialization.propertyList(from: pListData as Data, options: .mutableContainersAndLeaves, format: &format) as? NSArray
        } catch {
            print("Error reading plist")
        }
        
        if let barEntries = barEntries as? [[String:Any]] {
            for bar in barEntries {
                if let name = bar["Name"] as? String,
                    let latitude = bar["Latitude"] as? Double,
                    let longitude = bar["Longitude"] as? Double,
                    let image = bar["Image"] as? String
                {
                    let barEntry = Bar(name: name, imageName: image, latitude: latitude, longitude: longitude)
                    bars.append(barEntry)

                }
            }
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
