//
//  FavoriteMoviesRepositoryImpl.swift
//  MovieCatalogApp
//
//  Created by Богдан Тарченко on 28.10.2024.
//

class FavoriteMoviesRepositoryImpl: FavoriteMoviesRepository {
    private let httpClient: HTTPClient
    
    init(httpClient: HTTPClient) {
        self.httpClient = httpClient
    }
    
    func addToFavorites(movieID: String) async throws {
        let endpoint = AddMovieToFavoritesEndpoint(movieID: movieID)
        try await httpClient.sendRequestWithoutResponse(endpoint: endpoint, requestBody: nil as EmptyRequestModel?)
    }
    
    func getFavorites() async throws -> MoviesListResponseModel {
        let endpoint = GetFavoriteMoviesEndpoint()
        return try await httpClient.sendRequest(endpoint: endpoint, requestBody: nil as EmptyRequestModel?)
    }
}
