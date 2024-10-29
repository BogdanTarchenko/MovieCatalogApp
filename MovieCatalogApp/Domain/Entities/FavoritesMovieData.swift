//
//  FavoritesMovieData.swift
//  MovieCatalogApp
//
//  Created by Богдан Тарченко on 28.10.2024.
//

struct FavoritesMovieData {
    var posterURL: String
    var id: String

    init(posterURL: String = SC.empty, id: String = SC.empty) {
        self.posterURL = posterURL
        self.id = id
    }
}
