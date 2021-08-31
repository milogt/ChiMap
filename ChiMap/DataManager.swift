//
//  DataManager.swift
//  ChiMap
//
//  Created by Guo Tian on 2/11/21.
//

import Foundation
import MapKit

public class DataManager {
    var favorites = [MKAnnotation]()
    var names = [String]()
    
    init () {
        self.favorites = []
        self.names = []
    }
    
    func save(_ place:MKAnnotation) {
        favorites.append(place)
        names.append(place.title!!)
    }
    
    func delete(_ place:MKAnnotation) {
        if let index = names.firstIndex(of:place.title!!) {
            favorites.remove(at: index)
            names.remove(at: index)
        }
    }
    
}
