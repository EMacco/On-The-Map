//
//  UIViewController+Extension.swift
//  On the Map
//
//  Created by Emmanuel Okwara on 11/01/2020.
//  Copyright © 2020 Emmanuel Okwara. All rights reserved.
//

import Foundation
import UIKit
import ProgressHUD
import MapKit

extension UIViewController {
    @IBAction func logoutBtnClicked(_ sender: UIBarButtonItem) {
        ProgressHUD.show("Logging out...", interaction: false)
        NetworkClient.logout {
            DispatchQueue.main.async {
                ProgressHUD.dismiss()
                self.dismiss(animated: true, completion: nil)
            }
        }
    }
    
    @IBAction func addNewLocationBtnClicked(_ sender: UIBarButtonItem) {
        let controller = storyboard?.instantiateViewController(identifier: "addLocationNavigationController") as! UINavigationController
        
        self.present(controller, animated: true, completion: nil)
    }
}

extension UIViewController: MKMapViewDelegate {
    public func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        let reuseId = "pin"
        
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId) as? MKPinAnnotationView
        
        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            pinView!.canShowCallout = true
            pinView!.pinTintColor = .red
            pinView!.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
        }
        else {
            pinView!.annotation = annotation
        }
        
        return pinView
    }
    
    public func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if control == view.rightCalloutAccessoryView {
            if let toOpen = view.annotation?.subtitle! {
                UIApplication.shared.open(URL(string: toOpen)!, options: [:], completionHandler: nil)
            }
        }
    }
}
