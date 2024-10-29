//
//  FavoritesRepository.swift
//  MovieCatalogApp
//
//  Created by Богдан Тарченко on 28.10.2024.
//

protocol FavoriteMoviesRepository {
    func addToFavorites(movieID: String) async throws
    func getFavorites() async throws -> MoviesListResponseModel
}
