//
//  FeedMovieData.swift
//  MovieCatalogApp
//
//  Created by Богдан Тарченко on 21.10.2024.
//

struct FeedMovieData {
    var posterURL: String
    var name: String
    var year: Int
    var country: String
    var genres: [String]
    var id: String

    init(posterURL: String = SC.empty, name: String = SC.empty, year: Int = 0, country: String = SC.empty, genres: [String] = [], id: String = SC.empty) {
        self.posterURL = posterURL
        self.name = name
        self.year = year
        self.country = country
        self.genres = genres
        self.id = id
    }
}
