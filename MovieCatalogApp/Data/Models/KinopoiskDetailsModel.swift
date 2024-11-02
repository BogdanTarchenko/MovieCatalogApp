//
//  KinopoiskDetailsModel.swift
//  MovieCatalogApp
//
//  Created by Богдан Тарченко on 02.11.2024.
//

struct FilmSearchByFiltersResponse: Codable {
    let total: Int
    let totalPages: Int
    let items: [Film]
}

struct Film: Codable {
    let kinopoiskId: Int
    let imdbId: String?
    let nameRu: String?
    let nameEn: String?
    let nameOriginal: String?
    let countries: [Country]
    let genres: [KinopoiskGenre]
    let ratingKinopoisk: Double?
    let ratingImdb: Double?
    let year: Int?
    let type: FilmType
    let posterUrl: String
    let posterUrlPreview: String
}

struct Country: Codable {
    let country: String
}

struct KinopoiskGenre: Codable {
    let genre: String
}

enum FilmType: String, Codable {
    case film = "FILM"
    case tvShow = "TV_SHOW"
    case video = "VIDEO"
    case miniSeries = "MINI_SERIES"
    case tvSeries = "TV_SERIES"
    case unknown = "UNKNOWN"
}
