//
//  PlaceMarkerView.swift
//  ChiMap
//
//  Created by Guo Tian on 2/10/21.
//

import UIKit
import MapKit

class PlaceMarkerView: MKMarkerAnnotationView {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    override var annotation: MKAnnotation? {
        
        willSet {
            clusteringIdentifier = "Place"
            displayPriority = .defaultHigh
            markerTintColor = .systemRed
            glyphImage = UIImage(systemName: "pin.fill")
            titleVisibility = .visible
            subtitleVisibility = .hidden
        }
    }
    

    
}
