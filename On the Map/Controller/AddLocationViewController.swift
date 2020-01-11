//
//  AddLocationViewController.swift
//  On the Map
//
//  Created by Emmanuel Okwara on 12/01/2020.
//  Copyright © 2020 Emmanuel Okwara. All rights reserved.
//

import UIKit
import ProgressHUD
import MapKit

class AddLocationViewController: UIViewController {

    @IBOutlet weak var locationField: UITextField!
    @IBOutlet weak var websiteField: UITextField!
    @IBOutlet weak var findLocationBtn: UIButton!
    
    let newLocationPreviewVCIdentifier = "newLocationVC"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        findLocationBtn.toggleState(on: false)
    }
    
    @IBAction func valueChanged(_ sender: UITextField) {
        if !locationField.text!.isEmpty && !websiteField.text!.isEmpty {
            findLocationBtn.toggleState(on: true)
        } else {
            findLocationBtn.toggleState(on: false)
        }
    }
    
    @IBAction func findLocationBtnClicked(_ sender: UIButton) {
        ProgressHUD.show("Searching...", interaction: false)
        getCoordinateFromAddress(locationField.text!) { (coordinate) in
            if let coordinate = coordinate {
                ProgressHUD.dismiss()
                let controller = self.storyboard?.instantiateViewController(identifier: self.newLocationPreviewVCIdentifier) as! NewLocationPreviewViewController
                controller.newLocation = coordinate
                controller.websiteAddress = self.websiteField.text
                controller.mapString = self.locationField.text
                self.navigationController?.pushViewController(controller, animated: true)
            } else {
                "Location not found".showError()
            }
        }
    }
    
    func getCoordinateFromAddress(_ address: String, completion: @escaping(CLLocationCoordinate2D?) -> Void) {
        let geoCoder = CLGeocoder()
        geoCoder.geocodeAddressString(address) { (placemarks, error) in
            guard
                let placemarks = placemarks,
                let location = placemarks.first?.location
            else {
                return completion(nil)
            }

            completion(location.coordinate)
        }
    }
    
    @IBAction func cancelBtnClicked(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
}
