//
//  MovieDetailsViewModel.swift
//  MovieCatalogApp
//
//  Created by Богдан Тарченко on 31.10.2024.
//

import Foundation

class MovieDetailsViewModel: ObservableObject {
    
    @Published var movieID: String
    @Published var movieDetails: MovieDetails?
    @Published var favoritesMovieData = [FavoritesMovieData]()
    @Published var isFavorite: Bool = false
    @Published var kinopoiskData = KinopoiskDetails()
    
    private let getMovieDetailsUseCase: GetMovieDetailsUseCase
    private let getFavoriteMoviesUseCase: GetFavoriteMoviesUseCase
    private let addMovieToFavoritesUseCase: AddMovieToFavoritesUseCase
    private let deleteMovieFromFavoritesUseCase: DeleteMovieFromFavoritesUseCase
    private let getKinopoiskDetailsUseCase: GetKinopoiskDetailsUseCase
    
    var onDidLoadMovieDetails: ((MovieDetails) -> Void)?
    var onDidLoadKinopoiskDetails: ((KinopoiskDetails) -> Void)?
    var onDidStartLoad: (() -> Void)?
    var onDidFinishLoad: (() -> Void)?
    
    var onDismiss: (() -> Void)?

    init(movieID: String) {
        self.movieID = movieID
        
        self.getMovieDetailsUseCase = GetMovieDetailsUseCaseImpl.create()
        self.getFavoriteMoviesUseCase = GetFavoriteMoviesUseCaseImpl.create()
        self.addMovieToFavoritesUseCase = AddMovieToFavoritesUseCaseImpl.create()
        self.deleteMovieFromFavoritesUseCase = DeleteMovieFromFavoritesUseCaseImpl.create()
        self.getKinopoiskDetailsUseCase = GetKinopoiskDetailsUseCaseImpl.create()
        
        onDidLoad()
    }
    
    func onDidLoad() {
        notifyLoadingStart()
        
        Task {
            do {
                async let movieDetailsResult = fetchMovieDetails(movieID: movieID)
                async let favoritesMovieDataResult = fetchFavoritesMovieData()
                
                let details = try await movieDetailsResult
                let favorites = try await favoritesMovieDataResult
                
                let kinopoiskDetails = try await fetchKinopoiskDetails(yearFrom: details.year, yearTo: details.year, keyword: details.name)
                
                await MainActor.run {
                    self.favoritesMovieData = favorites
                    self.isFavorite = favorites.contains { $0.id == movieID }
                    self.movieDetails = details
                    self.kinopoiskData = kinopoiskDetails
                    notifyMovieDetailsLoaded(details)
                    
                    Task { @MainActor in
                        onDidLoadKinopoiskDetails?(kinopoiskData)
                    }
                    
                    notifyLoadingSuccess()
                }
            } catch {
                await MainActor.run {
                    notifyLoadingFinish()
                }
            }
        }
    }


    
    func addMovieToFavorites() {
        Task {
            try await addMovieToFavoritesUseCase.execute(movieID: movieID)
        }
    }
    
    func deleteMovieFromFavorites() {
        Task {
            try await deleteMovieFromFavoritesUseCase.execute(movieID: movieID)
        }
    }
    
    func dismissView() {
            onDismiss?()
    }
    
    // MARK: - Private Methods
    private func notifyLoadingStart() {
        Task { @MainActor in
            onDidStartLoad?()
        }
    }
    
    private func notifyMovieDetailsLoaded(_ movieDetails: MovieDetails) {
        Task { @MainActor in
            onDidLoadMovieDetails?(movieDetails)
        }
    }
    
    private func notifyLoadingSuccess() {
        Task { @MainActor in
            onDidFinishLoad?()
        }
    }
    
    private func notifyLoadingFinish() {
        Task { @MainActor in
            onDidFinishLoad?()
        }
    }
    
    private func fetchFavoritesMovieData() async throws -> [FavoritesMovieData] {
        let movies = try await getFavoriteMoviesUseCase.execute()
        return mapToFavoritesMovieData(movies)
    }
    
    private func fetchMovieDetails(movieID: String) async throws -> MovieDetails {
        let movie = try await getMovieDetailsUseCase.execute(movieID: movieID)
        return mapToMovieDetails(movie)
    }
    
    private func fetchKinopoiskDetails(yearFrom: Int, yearTo: Int, keyword: String) async throws -> KinopoiskDetails {
        let movie = try await getKinopoiskDetailsUseCase.execute(yearFrom: yearFrom, yearTo: yearTo, keyword: keyword)
        return mapToKinopoiskDetails(movie)
    }
    
    private func mapToFavoritesMovieData(_ movies: [MovieElementModel]) -> [FavoritesMovieData] {
        return movies.map { movie in
            FavoritesMovieData(
                posterURL: movie.poster ?? SC.empty,
                id: movie.id
            )
        }
    }
    
    private func mapToMovieDetails(_ movie: MovieDetailsModel) -> MovieDetails {
        return MovieDetails(
            id: movie.id,
            name: movie.name ?? SC.empty,
            poster: movie.poster ?? SC.empty,
            year: movie.year,
            country: movie.country ?? SC.empty,
            genres: movie.genres?.compactMap { $0 }.map { GenreDetails(id: $0.id, name: $0.name ?? SC.empty) } ?? [],
            reviews: movie.reviews?.compactMap { $0 }.map { ReviewDetails(
                id: $0.id,
                rating: $0.rating,
                reviewText: $0.reviewText ?? SC.empty,
                isAnonymous: $0.isAnonymous,
                createDateTime: $0.createDateTime,
                author: AuthorDetails(
                    userId: $0.author.userId,
                    nickName: $0.author.nickName ?? SC.empty,
                    avatar: $0.author.avatar ?? SC.empty
                )
            ) } ?? [],
            time: movie.time,
            tagline: movie.tagline ?? SC.empty,
            description: movie.description ?? SC.empty,
            director: movie.director ?? SC.empty,
            budget: movie.budget ?? 0,
            fees: movie.fees ?? 0,
            ageLimit: movie.ageLimit
        )
    }
    
    private func mapToKinopoiskDetails(_ movie: FilmSearchByFiltersResponse) -> KinopoiskDetails {
        return KinopoiskDetails(
            kinopoiskId: movie.items.first?.kinopoiskId ?? 0,
            ratingKinoposik: movie.items.first?.ratingKinopoisk ?? 0,
            ratingImdb: movie.items.first?.ratingImdb ?? 0
        )
    }
}
