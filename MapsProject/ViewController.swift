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
    var tappedBarWebsite = ""
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "showWeb" {
            
            guard let navVC = segue.destination as? UINavigationController,
                let webVC = navVC.topViewController as? WebViewController else {
                print("navVC or webVC is nil")
                return
            }
            webVC.userUrl = tappedBarWebsite
            print(webVC.userUrl)
        }
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        
        guard let tappedBar = view.annotation as? Bar else{
            print("tappedBar is nil")
            return
        }
        
        if control == view.rightCalloutAccessoryView {
          
            tappedBarWebsite = tappedBar.website
            performSegue(withIdentifier: "showWeb", sender: self)
        }
    }
    
    //This method deals with annotations(pins).
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        //Check if the annotation is currently not the current user being displayed on the map
        //If it is, return nothing
        if annotation is MKUserLocation {
            return nil
        }
        
        //Get first annotation and make sure to allow it to dequeue annotations to optimize memory usage
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: "barLocation") as? MKPinAnnotationView
        //If annotation is nil, create a new annotationView. Else, once the data has been dequeued, you must update the annotation
        if annotationView == nil {
            annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: "barLocation")
        } else {
            annotationView?.annotation = annotation
        }
        //Setting data to all pins
        annotationView?.pinTintColor = UIColor.red
        annotationView?.canShowCallout = true
        if let place = annotation as? Bar, let image = place.image {
            
            //Left accessory
            let imageView = UIImageView(image: image)
            imageView.contentMode = .scaleAspectFit
            imageView.frame = CGRect(x: 0, y: 0, width: (annotationView?.frame.width)!, height: (annotationView?.frame.height)!)
            annotationView?.leftCalloutAccessoryView = imageView
            
            //Right accessory 
            let infoButton = UIButton(type: .detailDisclosure)
            annotationView?.rightCalloutAccessoryView = infoButton
        }
        return annotationView
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
                    let image = bar["Image"] as? String,
                    let website = bar["Website"] as? String
                {
                    let barEntry = Bar(name: name, imageName: image, latitude: latitude, longitude: longitude, websiteURL: website)
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
