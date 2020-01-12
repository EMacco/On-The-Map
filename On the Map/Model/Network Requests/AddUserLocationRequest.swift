//
//  AddUserLocationRequest.swift
//  On the Map
//
//  Created by Emmanuel Okwara on 12/01/2020.
//  Copyright © 2020 Emmanuel Okwara. All rights reserved.
//

import Foundation

struct AddUserLocationRequest: Encodable {
    let uniqueKey: String
    let firstName: String
    let lastName: String
    let mapString: String
    let mediaURL: String
    let latitude: Double
    let longitude: Double
}
