//
//  Bars.swift
//  MapsProject
//
//  Created by Miguel Tepale on 5/12/17.
//  Copyright © 2017 Miguel Tepale. All rights reserved.
//

import UIKit
import MapKit

class Bar: NSObject {
    
    let name: String
    let location: CLLocation
    let image: UIImage?
    
    init(name: String, imageName: String, latitude: Double, longitude: Double) {
        
        self.name = name
        self.location = CLLocation(latitude: latitude, longitude: longitude)
        self.image = UIImage(named: imageName)
    }
}

extension Bar: MKAnnotation {
    var coordinate: CLLocationCoordinate2D {
        get {
            return location.coordinate
         }
        }
    var title: String? {
        get{
            return name
         }
        }
    }
