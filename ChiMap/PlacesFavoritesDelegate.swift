//
//  PlacesFavoritesDelegate.swift
//  ChiMap
//
//  Created by Guo Tian on 2/11/21.
//

import Foundation
import UIKit

protocol PlacesFavoritesDelegate: class {
    
    func favoritePlace(name: String) -> Void
    
}
