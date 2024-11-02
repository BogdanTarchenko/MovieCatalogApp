//
//  KinopoiskRepository.swift
//  MovieCatalogApp
//
//  Created by Богдан Тарченко on 02.11.2024.
//

class KinoposkRepositoryImpl: KinopoiskRepository {
    private let httpClient: HTTPClient
    
    init(httpClient: HTTPClient) {
        self.httpClient = httpClient
    }
    
    func getKinopoiskDetails(yearFrom: Int, yearTo: Int, keyword: String) async throws -> FilmSearchByFiltersResponse {
        let endpoint = GetKinopoiskDetailsEndpoint(yearFrom: yearFrom, yearTo: yearTo, keyword: keyword)
        return try await httpClient.sendRequest(endpoint: endpoint, requestBody: nil as EmptyRequestModel?)
    }
    
    func getDirectorPoster(name: String) async throws -> PersonByNameResponse {
        let endpoint = GetPersonByNameEndpoint(name: name)
        return try await httpClient.sendRequest(endpoint: endpoint, requestBody: nil as EmptyRequestModel?)
    }
}
