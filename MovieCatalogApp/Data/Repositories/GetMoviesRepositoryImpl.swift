//
//  GetMoviesRepositoryImpl.swift
//  MovieCatalogApp
//
//  Created by Богдан Тарченко on 20.10.2024.
//

class GetMoviesRepositoryImpl: GetMoviesRepository {
    private let httpClient: HTTPClient
    
    init(httpClient: HTTPClient) {
        self.httpClient = httpClient
    }
    
    func getMovies(page: Int) async throws -> MoviesPagedListResponseModel {
        let endpoint = MoviesPagedListEndpoint(page: page)
        return try await httpClient.sendRequest(endpoint: endpoint, requestBody: nil as EmptyRequestModel?)
    }
}
