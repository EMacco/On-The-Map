//
//  LoginResponse.swift
//  On the Map
//
//  Created by Emmanuel Okwara on 11/01/2020.
//  Copyright © 2020 Emmanuel Okwara. All rights reserved.
//

import Foundation

struct LoginResponse: Decodable {
    let account: Account
    let session: Session
}
