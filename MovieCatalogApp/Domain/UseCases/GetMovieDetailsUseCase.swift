//
//  GetMovieDetailsUseCase.swift
//  MovieCatalogApp
//
//  Created by Богдан Тарченко on 01.11.2024.
//

protocol GetMovieDetailsUseCase {
    func execute(movieID: String) async throws -> MovieDetailsModel
}

class GetMovieDetailsUseCaseImpl: GetMovieDetailsUseCase {
    private let repository: GetMoviesRepository
    
    init(repository: GetMoviesRepository) {
        self.repository = repository
    }
    
    static func create() -> GetMovieDetailsUseCaseImpl {
        let httpClient = AlamofireHTTPClient(baseURL: .kreosoft)
        let repository = GetMoviesRepositoryImpl(httpClient: httpClient)
        return GetMovieDetailsUseCaseImpl(repository: repository)
    }
    
    func execute(movieID: String) async throws -> MovieDetailsModel {
        return try await repository.getMovieDetails(movieID: movieID)
    }
}
