//
//  LoginRequest.swift
//  On the Map
//
//  Created by Emmanuel Okwara on 11/01/2020.
//  Copyright © 2020 Emmanuel Okwara. All rights reserved.
//

import Foundation

struct LoginRequest: Encodable {
    let udacity: LoginCredentials
}

struct LoginCredentials: Encodable {
    let username: String
    let password: String
}
