//
//  PersonDetails.swift
//  MovieCatalogApp
//
//  Created by Богдан Тарченко on 02.11.2024.
//

import Foundation

struct PersonDetails {
    let posterURL: String
    
    init(posterURL: String = SC.empty) {
        self.posterURL = posterURL
    }
}
