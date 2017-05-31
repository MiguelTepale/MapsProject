//
//  CustomAnnotations.swift
//  MapsProject
//
//  Created by Miguel Tepale on 5/12/17.
//  Copyright © 2017 Miguel Tepale. All rights reserved.
//

import UIKit
import MapKit

class SearchResult: NSObject {
    
    let name: String
    let image: UIImage?
    let location: CLLocation
    let website: String
    
    init(name: String, imageName: String, latitude: Double, longitude: Double, websiteURL: String) {
        
        self.name = name
        self.image = UIImage(named: imageName)
        self.location = CLLocation(latitude: latitude, longitude: longitude)
        self.website = websiteURL
    }
}

extension SearchResult: MKAnnotation {
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

extension SearchResult {
    convenience init?(_ item: MKMapItem) {
        guard let name = item.name,
            let websiteURL = item.url?.absoluteString else {
                return nil
        }
        let imageName = "menu.png"
        let latitude = item.placemark.coordinate.latitude
        let longitude = item.placemark.coordinate.longitude
        
        self.init(name: name, imageName: imageName, latitude: latitude, longitude: longitude, websiteURL: websiteURL)
    }
}
