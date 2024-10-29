//
//  GetFavoriteMoviesUseCase.swift
//  MovieCatalogApp
//
//  Created by Богдан Тарченко on 28.10.2024.
//

protocol GetFavoriteMoviesUseCase {
    func execute() async throws -> [MovieElementModel]
}

class GetFavoriteMoviesUseCaseImpl: GetFavoriteMoviesUseCase {
    private let repository: FavoriteMoviesRepository
    
    init(repository: FavoriteMoviesRepository) {
        self.repository = repository
    }
    
    static func create() -> GetFavoriteMoviesUseCaseImpl {
        let httpClient = AlamofireHTTPClient(baseURL: .kreosoft)
        let repository = FavoriteMoviesRepositoryImpl(httpClient: httpClient)
        return GetFavoriteMoviesUseCaseImpl(repository: repository)
    }
    
    func execute() async throws -> [MovieElementModel] {
        let movies = try await repository.getFavorites()
        return movies.movies ?? []
    }
}
