//
//  GetMoviesRepository.swift
//  MovieCatalogApp
//
//  Created by Богдан Тарченко on 20.10.2024.
//

protocol GetMoviesRepository {
    func getMovies(page: Int) async throws -> MoviesPagedListResponseModel
    func getMovieDetails(movieID: String) async throws -> MovieDetailsModel
}
