//
//  ErrorResponse.swift
//  On the Map
//
//  Created by Emmanuel Okwara on 11/01/2020.
//  Copyright © 2020 Emmanuel Okwara. All rights reserved.
//

import Foundation

struct ErrorResponse: Decodable {
    let status: Int
    let error: String
}

extension ErrorResponse: LocalizedError {
    var errorDescription: String? {
        return error
    }
}
