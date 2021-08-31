//
//  Place.swift
//  ChiMap
//
//  Created by Guo Tian on 2/10/21.
//

import Foundation
import MapKit

class Place: MKPointAnnotation {
    var name: String?
    var longDescription: String?
    
    init(name:String, description:String, coord:CLLocationCoordinate2D) {
        self.name = name
        self.longDescription = description
        
        super.init()
        self.coordinate = coord
        self.title = name
        self.subtitle = longDescription
    }
}
