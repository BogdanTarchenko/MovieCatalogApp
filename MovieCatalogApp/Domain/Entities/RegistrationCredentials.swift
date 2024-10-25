//
//  RegistrationCredentials.swift
//  MovieCatalogApp
//
//  Created by Богдан Тарченко on 13.10.2024.
//

import Foundation

struct RegistrationCredentials {
    var username: String
    var email: String
    var name: String
    var password: String
    var repeatedPassword: String
    var dateOfBirth: Date?
    var gender: Gender
    
    init(username: String = SC.empty, email: String = SC.empty, name: String = SC.empty, password: String = SC.empty, repeatedPassword: String = SC.empty, dateOfBirth: Date? = nil, gender: Gender = .female) {
        self.username = username
        self.email = email
        self.name = name
        self.password = password
        self.repeatedPassword = repeatedPassword
        self.dateOfBirth = dateOfBirth
        self.gender = gender
    }
}
