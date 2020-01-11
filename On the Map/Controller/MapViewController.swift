//
//  MapViewController.swift
//  On the Map
//
//  Created by Emmanuel Okwara on 10/01/2020.
//  Copyright © 2020 Emmanuel Okwara. All rights reserved.
//

import UIKit
import ProgressHUD
import MapKit

class MapViewController: UIViewController {
    
    @IBOutlet weak var mapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fetchUserDetails()
        mapView.register(MKMarkerAnnotationView.self, forAnnotationViewWithReuseIdentifier: MKMapViewDefaultClusterAnnotationViewReuseIdentifier)
    }
    
    @IBAction func reloadBtnClicked(_ sender: UIBarButtonItem) {
        ProgressHUD.show("Refreshing...", interaction: false)
        fetchStudentsLocation()
    }
    
    func placeMarkers() {
        var userAnnotation: StudentAnnotation?
        for student in StudentLocationManager.shared.getAllStudents() {
            let coordinate = CLLocationCoordinate2D(latitude: student.latitude, longitude: student.longitude)
            let annotation = StudentAnnotation(coordinate: coordinate, title: student.firstName + " " + student.lastName, subtitle: student.mediaURL)
            mapView.addAnnotation(annotation)
            
            if student.uniqueKey == NetworkClient.Auth.userId {
                userAnnotation = annotation
            }
        }
        
        if let userAnnotation = userAnnotation {
            mapView.setRegion(userAnnotation.region, animated: true)
        }
    }
    
    func fetchUserDetails() {
        ProgressHUD.show("Loading...", interaction: false)
        NetworkClient.fetchUserData(completion: handleUserDataResponse(success:error:))
    }
    
    func fetchStudentsLocation() {
        NetworkClient.fetchStudentsLocation(limit: 100, completion: handleStudentsLocationResponse(success:error:))
    }
    
    func handleStudentsLocationResponse(success: Bool, error: Error?) {
        if success {
            ProgressHUD.dismiss()
            placeMarkers()
        } else {
            (error?.localizedDescription ?? "").showError()
        }
    }
    
    func handleUserDataResponse(success: Bool, error: Error?) {
        if success {
            fetchStudentsLocation()
        } else {
            (error?.localizedDescription ?? "").showError()
        }
    }
    
    @IBAction func prepareForSegue(_ segue: UIStoryboardSegue) {}
    
}
