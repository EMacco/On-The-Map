//
//  StudentLocationManager.swift
//  On the Map
//
//  Created by Emmanuel Okwara on 11/01/2020.
//  Copyright © 2020 Emmanuel Okwara. All rights reserved.
//

import Foundation

class StudentLocationManager {
    static let shared = StudentLocationManager()
    private var students = [LocationResult]()
    
    private init() {}
    
    func setStudents(students: [LocationResult]) {
        self.students = students
    }
    
    func getAllStudents() -> [LocationResult] {
        return students
    }
}
