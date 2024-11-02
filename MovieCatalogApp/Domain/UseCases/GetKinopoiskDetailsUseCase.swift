//
//  GetKinopoiskDetailsUseCase.swift
//  MovieCatalogApp
//
//  Created by Богдан Тарченко on 02.11.2024.
//

protocol GetKinopoiskDetailsUseCase {
    func execute(yearFrom: Int, yearTo: Int, keyword: String) async throws -> FilmSearchByFiltersResponse
}

class GetKinopoiskDetailsUseCaseImpl: GetKinopoiskDetailsUseCase {
    private let repository: KinopoiskRepository
    
    init(repository: KinopoiskRepository) {
        self.repository = repository
    }
    
    static func create() -> GetKinopoiskDetailsUseCaseImpl {
        let httpClient = AlamofireHTTPClient(baseURL: .kinopoisk)
        let repository = KinoposkRepositoryImpl(httpClient: httpClient)
        return GetKinopoiskDetailsUseCaseImpl(repository: repository)
    }
    
    func execute(yearFrom: Int, yearTo: Int, keyword: String) async throws -> FilmSearchByFiltersResponse {
        return try await repository.getKinopoiskDetails(yearFrom: yearFrom, yearTo: yearTo, keyword: keyword)
    }
}
