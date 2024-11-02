//
//  GetPersonByNameUseCase.swift
//  MovieCatalogApp
//
//  Created by Богдан Тарченко on 02.11.2024.
//

protocol GetPersonByNameUseCase {
    func execute(name: String) async throws -> PersonByNameResponse
}

class GetPersonByNameUseCaseImpl: GetPersonByNameUseCase {
    private let repository: KinopoiskRepository
    
    init(repository: KinopoiskRepository) {
        self.repository = repository
    }
    
    static func create() -> GetPersonByNameUseCaseImpl {
        let httpClient = AlamofireHTTPClient(baseURL: .kinopoisk)
        let repository = KinoposkRepositoryImpl(httpClient: httpClient)
        return GetPersonByNameUseCaseImpl(repository: repository)
    }
    
    func execute(name: String) async throws -> PersonByNameResponse {
        return try await repository.getDirectorPoster(name: name)
    }
}
