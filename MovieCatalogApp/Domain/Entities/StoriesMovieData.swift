//
//  StoriesMovieData.swift
//  MovieCatalogApp
//
//  Created by Богдан Тарченко on 27.10.2024.
//

struct StoriesMovieData {
    var posterURL: String
    var name: String
    var genres: [String]
    var id: String

    // TODO: - убрать стандартную инициализацию
    init(posterURL: String = SC.empty, name: String = SC.empty, genres: [String] = [], id: String = SC.empty) {
        self.posterURL = posterURL
        self.name = name
        self.genres = genres
        self.id = id
    }
}
