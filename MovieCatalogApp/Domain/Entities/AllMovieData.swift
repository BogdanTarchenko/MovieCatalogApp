//
//  AllMovieData.swift
//  MovieCatalogApp
//
//  Created by Богдан Тарченко on 29.10.2024.
//

struct AllMovieData {
    var posterURL: String
    var id: String
    var reviews: [ReviewShort]

    init(posterURL: String = SC.empty, id: String = SC.empty, reviews: [ReviewShort] = []) {
        self.posterURL = posterURL
        self.id = id
        self.reviews = reviews
    }
}

struct ReviewShort {
    var id: String
    var rating: Int
}
