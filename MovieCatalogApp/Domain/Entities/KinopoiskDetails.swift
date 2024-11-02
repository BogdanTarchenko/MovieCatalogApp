//
//  KinopoiskDetails.swift
//  MovieCatalogApp
//
//  Created by Богдан Тарченко on 02.11.2024.
//

import Foundation

struct KinopoiskDetails {
    let kinopoiskId: Int
    let ratingKinoposik: Double
    let ratingImdb: Double
    
    init(kinopoiskId: Int = 0, ratingKinoposik: Double = 0, ratingImdb: Double = 0) {
        self.kinopoiskId = kinopoiskId
        self.ratingKinoposik = ratingKinoposik
        self.ratingImdb = ratingImdb
    }
}
