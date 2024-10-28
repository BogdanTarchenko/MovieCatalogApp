//
//  AddMovieToFavoritesUseCase.swift
//  MovieCatalogApp
//
//  Created by Богдан Тарченко on 28.10.2024.
//

protocol AddMovieToFavoritesUseCase {
    func execute(movieID: String) async throws
}

class AddMovieToFavoritesUseCaseImpl: AddMovieToFavoritesUseCase {
    private let repository: FavoriteMoviesRepository
    
    init(repository: FavoriteMoviesRepository) {
        self.repository = repository
    }
    
    static func create() -> AddMovieToFavoritesUseCaseImpl {
        let httpClient = AlamofireHTTPClient(baseURL: .kreosoft)
        let repository = FavoriteMoviesRepositoryImpl(httpClient: httpClient)
        return AddMovieToFavoritesUseCaseImpl(repository: repository)
    }
    
    func execute(movieID: String) async throws {
        do {
            try await repository.addToFavorites(movieID: movieID)
        } catch {
            throw error
        }
    }
}
