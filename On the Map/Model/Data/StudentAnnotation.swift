 //
//  StudentAnnotation.swift
//  On the Map
//
//  Created by Emmanuel Okwara on 12/01/2020.
//  Copyright © 2020 Emmanuel Okwara. All rights reserved.
//

import Foundation
import MapKit
 
 final class StudentAnnotation: NSObject, MKAnnotation {
    let coordinate: CLLocationCoordinate2D
    let title: String?
    let subtitle: String?
    
    init(coordinate: CLLocationCoordinate2D, title: String?, subtitle: String?) {
        self.coordinate = coordinate
        self.title = title
        self.subtitle = subtitle
        
        super.init()
    }
    
    var region: MKCoordinateRegion {
        let span = MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
        return MKCoordinateRegion(center: coordinate, span: span)
    }
 }
