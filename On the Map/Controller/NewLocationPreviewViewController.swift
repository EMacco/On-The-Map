//
//  NewLocationPreviewViewController.swift
//  On the Map
//
//  Created by Emmanuel Okwara on 12/01/2020.
//  Copyright © 2020 Emmanuel Okwara. All rights reserved.
//

import UIKit
import MapKit
import ProgressHUD

class NewLocationPreviewViewController: UIViewController {

    var newLocation: CLLocationCoordinate2D!
    var websiteAddress: String!
    var mapString: String!
    @IBOutlet weak var mapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Preview Location"
    }
    
    override func viewDidAppear(_ animated: Bool) {
        setupMap()
    }
    
    func setupMap() {
        mapView.register(MKMarkerAnnotationView.self, forAnnotationViewWithReuseIdentifier: MKMapViewDefaultClusterAnnotationViewReuseIdentifier)
        let student = NetworkClient.Auth.user!
        let coordinate = CLLocationCoordinate2D(latitude: newLocation.latitude, longitude: newLocation.longitude)
        let annotation = StudentAnnotation(coordinate: coordinate, title: student.firstName + " " + student.lastName, subtitle: websiteAddress)
        mapView.addAnnotation(annotation)
        mapView.setRegion(annotation.region, animated: true)
    }

    @IBAction func saveLocationBtnClicked(_ sender: UIButton) {
        if let id = userAlreadyHasLocation() {
            let alert = UIAlertController(title: "Overwrite Location", message: "Are you sure you want to overwite your current location?", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { (_) in
                ProgressHUD.show("Saving...", interaction: false)
                NetworkClient.updateLocation(mapString: self.mapString, mediaURL: self.websiteAddress, latitude: self.newLocation.latitude, longitude: self.newLocation.longitude, id: id, completion: self.handleAddLocationCompletion(success:error:))
            }))
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            present(alert, animated: true, completion: nil)
        } else {
            ProgressHUD.show("Saving...", interaction: false)
            NetworkClient.addNewLocation(mapString: mapString, mediaURL: websiteAddress, latitude: newLocation.latitude, longitude: newLocation.longitude, completion: handleAddLocationCompletion(success:error:))
        }
    }
    
    func handleAddLocationCompletion(success: Bool, error: Error?) {
        if success {
            ProgressHUD.showSuccess()
            performSegue(withIdentifier: "returnToHome", sender: nil)
        } else {
            (error?.localizedDescription ?? "").showError()
        }
    }
    
    func userAlreadyHasLocation() -> String? {
        let user = StudentLocationManager.shared.getAllStudents().filter { $0.uniqueKey == NetworkClient.Auth.userId }
        return user.first?.objectId
    }
    
}
