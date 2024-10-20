//
//  LoginCredentials.swift
//  MovieCatalogApp
//
//  Created by Богдан Тарченко on 13.10.2024.
//

import Foundation

struct LoginCredentials {
    var username: String
    var password: String
    
    init(username: String = SC.empty, password: String = SC.empty) {
        self.username = username
        self.password = password
    }
}
