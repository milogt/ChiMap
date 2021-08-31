//
//  FavoritesViewController.swift
//  ChiMap
//
//  Created by Guo Tian on 2/11/21.
//

import UIKit

class FavoritesViewController: UIViewController {

    @IBOutlet weak var exitButton: UIButton!
    @IBOutlet weak var favoriteTable: UITableView!
    
    weak var delegate: PlacesFavoritesDelegate?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        exitButton.addTarget(self,action: #selector(self.tapButton(sender:)),
                             for: UIControl.Event.touchUpInside)
        favoriteTable.delegate = self
        favoriteTable.dataSource = self
        self.view.addSubview(favoriteTable)
    }
    
    @objc func tapButton(sender: UIButton!) {
        self.dismiss(animated: true, completion: nil)
    }

}

// delegation setup refer to:
// https://abhimuralidharan.medium.com/all-about-protocols-in-swift-11a72d6ea354
extension FavoritesViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.dismiss(animated: true, completion: nil)
        delegate?.favoritePlace(name:MapViewController.sharedInstance.names[indexPath.row])
    }
}

extension FavoritesViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = MapViewController.sharedInstance.names[indexPath.row]
        cell.detailTextLabel?.text = MapViewController.sharedInstance.favorites[indexPath.row].subtitle as? String
        return cell
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return MapViewController.sharedInstance.names.count
        }
    
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        if UIDevice.current.orientation.isLandscape {
//            return 60
//        }
//        else {
//            return 50
//        }
//    }
    
}
