//
//  ViewController.swift
//  ChiMap
//
//  Created by Guo Tian on 2/9/21.
//

import UIKit
import MapKit

class MapViewController: UIViewController, MKMapViewDelegate {
        
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var detailView: UIView!
    @IBOutlet weak var detailTitle: UILabel!
    @IBOutlet weak var detailDescription: UILabel!
    @IBOutlet weak var detailButton: UIButton!
    @IBOutlet weak var favoriteButton: UIButton!
    var heightAnchor:NSLayoutConstraint!
    
    public static let sharedInstance = DataManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapView.delegate = self
        mapView.translatesAutoresizingMaskIntoConstraints = false
        mapView.showsCompass = false
        mapView.pointOfInterestFilter = .excludingAll
        let chicago = CLLocationCoordinate2D(latitude: 41.8781, longitude: -87.6298)
        mapView.setRegion(MKCoordinateRegion(center: chicago, span: MKCoordinateSpan(latitudeDelta: 0.4, longitudeDelta: 0.4)), animated: true)
        
        heightAnchor = detailView.heightAnchor.constraint(equalToConstant: 95)
        heightAnchor.isActive = true
        detailView.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        detailButton.setImage(UIImage(systemName: "star"), for: .normal)
        self.view.sendSubviewToBack(detailView)
        
        // annotation setup refer to:
        // https://sarunw.com/posts/how-to-read-plist-file/
        if let infoPlistPath = Bundle.main.url(forResource: "Data", withExtension: "plist") {
            do {
                let infoPlistData = try Data(contentsOf: infoPlistPath)
                if let dict = try PropertyListSerialization.propertyList(from: infoPlistData, options: [], format: nil) as? [String: Any] {
                    let landmarks = (dict["places"]! as? [[String : Any]])!
                    for i in 0...landmarks.count-1 {
                        let place1 = Place(name:landmarks[i]["name"]! as! String, description:landmarks[i]["description"]! as! String,coord:CLLocationCoordinate2D(latitude: landmarks[i]["lat"]! as! CLLocationDegrees,longitude: landmarks[i]["long"]! as! CLLocationDegrees))
                        mapView.addAnnotation(place1)
                    }
                }
            } catch {
                print(error)
            }
        }
        detailButton.addTarget(self,action: #selector(self.tapFavorite(sender:)),
                             for: UIControl.Event.touchUpInside)
    }
        
    @objc func tapFavorite(sender: UIButton!){
        if MapViewController.sharedInstance.names.contains(mapView.selectedAnnotations[0].title!!) {
            MapViewController.sharedInstance.delete(mapView.selectedAnnotations[0])
            detailButton.setImage(UIImage(systemName: "star"), for: .normal)
        }
        else {
            MapViewController.sharedInstance.save(mapView.selectedAnnotations[0])
            detailButton.setImage(UIImage(systemName: "star.fill"), for: .normal)
        }
        print(MapViewController.sharedInstance.names)
    }

    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        if let clusterAnnotation = view.annotation as? MKClusterAnnotation {
            mapView.setRegion(MKCoordinateRegion(center: clusterAnnotation.memberAnnotations[0].coordinate, span: MKCoordinateSpan(latitudeDelta: 0.03, longitudeDelta: 0.03)), animated: true)
        }
        else {
            if let annotation = view.annotation {
                detailTitle.text = annotation.title as? String
                detailDescription.text = annotation.subtitle as? String
                if MapViewController.sharedInstance.names.contains(annotation.title!!){
                    detailButton.setImage(UIImage(systemName: "star.fill"), for: .normal)
                }
                else{
                    detailButton.setImage(UIImage(systemName: "star"), for: .normal)
                }
                self.view.bringSubviewToFront(detailView)
            }
        }
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard annotation is Place else { return nil }
        let annotationView = PlaceMarkerView()
        return annotationView
    }
    
    // create reference between viewcontroller in storyboard refer to:
    //https://stackoverflow.com/questions/25436433/ios-how-to-get-a-reference-to-a-view-controller-embedded-in-a-storyboard-contain
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "favoButton") {
            let fpvc = segue.destination as? FavoritesViewController
            fpvc!.delegate = self
        }
    }
    // deselect an annotation to dismiss details refer to:
    // https://developer.apple.com/documentation/mapkit/mkmapview/1451988-deselectannotation
    func mapView(_ mapView: MKMapView, didDeselect view: MKAnnotationView) {
        self.view.sendSubviewToBack(detailView)
    }
    
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        if UIDevice.current.orientation.isLandscape {
            heightAnchor.constant = 250
        }
        else if UIDevice.current.orientation.isPortrait{
            heightAnchor.constant = 95
        }
    }
}

extension MapViewController:PlacesFavoritesDelegate {
    func favoritePlace(name: String) {
        print(name)
        if let index = MapViewController.sharedInstance.names.firstIndex(of:name) {
            let destination = MapViewController.sharedInstance.favorites[index]
//            print(destination)
            mapView.setRegion(MKCoordinateRegion(center: destination.coordinate, span: MKCoordinateSpan(latitudeDelta: 0.03, longitudeDelta: 0.03)), animated: true)
            mapView.selectAnnotation(destination, animated: true)
        }
    }
}

