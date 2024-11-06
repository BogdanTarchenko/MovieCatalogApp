//
//  FavoritesViewModel.swift
//  MovieCatalogApp
//
//  Created by Богдан Тарченко on 04.11.2024.
//

import Foundation

protocol FavoritesViewModelRouterDelegate: AnyObject {
    func navigateToMain()
    func navigateToMovieDetails(movieID: String)
    func navigateToWelcome()
}

class FavoritesViewModel: ObservableObject {
    
    weak var delegate: FavoritesViewModelRouterDelegate?
    
    @Published var isFavoritesEmpty: Bool = false
    @Published var currentUserId: String = SC.empty
    @Published var favoriteGenres: [FavoriteGenre] = []
    @Published var favoriteMovies: [AllMovieData] = []
    
    private let dataController = DataController.shared
    private let getFavoriteMoviesUseCase: GetFavoriteMoviesUseCase
    private let getUserDataUseCase: GetUserDataUseCase
    
    init() {
        self.getFavoriteMoviesUseCase = GetFavoriteMoviesUseCaseImpl.create()
        self.getUserDataUseCase = GetUserDataUseCaseImpl.create()
        
        Task {
            await updateFavoritesStatus()
        }
    }
    
    @MainActor
    func updateFavoritesStatus() async {
        do {
            currentUserId = try await getUserDataUseCase.execute().id
            let favoriteMoviesResult = try await fetchFavoriteMovieData()
            favoriteMovies = favoriteMoviesResult
            favoriteGenres = dataController.getFavoriteGenres(for: currentUserId)
            isFavoritesEmpty = favoriteMovies.isEmpty && favoriteGenres.isEmpty
        } catch {
            print(error)
        }
    }
    
    func findFilmButtonTapped() {
        delegate?.navigateToMain()
    }
    
    func filmTapped(movieID: String) {
        delegate?.navigateToMovieDetails(movieID: movieID)
    }
    
    func removeGenre(genreName: String) {
        if let index = favoriteGenres.firstIndex(where: { $0.name == genreName }) {
            favoriteGenres.remove(at: index)
        }
        dataController.removeFavoriteGenre(for: currentUserId, genreName: genreName)
        isFavoritesEmpty = favoriteMovies.isEmpty && favoriteGenres.isEmpty
        Task {
            await updateFavoritesStatus()
        }
    }
    
    private func mapToAllMovieData(_ movies: [MovieElementModel]) -> [AllMovieData] {
        return movies.map { movie in
            AllMovieData(
                posterURL: movie.poster ?? SC.empty,
                id: movie.id,
                reviews: movie.reviews?.map { ReviewShort(id: $0.id, rating: $0.rating) } ?? []
            )
        }
    }
    
    private func fetchFavoriteMovieData() async throws -> [AllMovieData] {
        let movie = try await getFavoriteMoviesUseCase.execute()
        return mapToAllMovieData(movie)
    }
}
