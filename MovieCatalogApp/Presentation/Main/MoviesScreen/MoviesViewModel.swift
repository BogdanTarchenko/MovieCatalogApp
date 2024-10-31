//
//  MoviesViewModel.swift
//  MovieCatalogApp
//
//  Created by Богдан Тарченко on 27.10.2024.
//

import Foundation

final class MoviesViewModel {
    
    private let getMoviesUseCase: GetMoviesForStoriesUseCase
    private let getFavoriteMoviesUseCase: GetFavoriteMoviesUseCase
    private let getAllMoviesUseCase: GetAllMoviesUseCase
    
    var storiesMovieData = [StoriesMovieData]()
    var favoritesMovieData = [FavoritesMovieData]()
    var allMovieData = [AllMovieData]()
    
    var onDidLoadStoriesMovieData: (([StoriesMovieData]) -> Void)?
    var onDidLoadFavoritesMovieData: (([FavoritesMovieData]) -> Void)?
    var onDidLoadAllMovieData: (([AllMovieData]) -> Void)?
    var onDidStartLoad: (() -> Void)?
    var onDidFinishLoad: (() -> Void)?
    
    private var isLoading = false
    
    init() {
        self.getMoviesUseCase = GetMoviesForStoriesUseCaseImpl.create()
        self.getFavoriteMoviesUseCase = GetFavoriteMoviesUseCaseImpl.create()
        self.getAllMoviesUseCase = GetAllMoviesUseCaseImpl.create()
    }
    
    // MARK: - Public Methods
    func onDidLoad() {
        notifyLoadingStart()
        
        Task {
            do {
                async let storiesMovieDataResult = try await fetchStoriesMovieData()
                async let favoritesMovieDataResult = try await fetchFavoritesMovieData()
                async let allMoviesDataResult = try await fetchInitialMovieData()
                
                (storiesMovieData, favoritesMovieData, allMovieData) = await (try storiesMovieDataResult, try favoritesMovieDataResult, try allMoviesDataResult)
                
                notifyLoadingSuccess()
            } catch {
                notifyLoadingFinish()
            }
        }
    }
    
    func onDidScrolledToEnd() {
        guard !isLoading else {
            return
        }
        
        isLoading = true
        
        Task {
            let movies = try await getAllMoviesUseCase.execute()
            if let movies = movies, !movies.isEmpty {
                allMovieData.append(contentsOf: mapToAllMovieData(movies))
            }
            isLoading = false
        }
    }
    
    func onDidUpdateFavorites() async {
        let movies = try? await getFavoriteMoviesUseCase.execute()
        favoritesMovieData = mapToFavoritesMovieData(movies ?? [])
    }
    
    // MARK: - Private Methods
    private func notifyLoadingStart() {
        Task { @MainActor in
            onDidStartLoad?()
        }
    }
    
    private func notifyLoadingSuccess() {
        Task { @MainActor in
            onDidLoadStoriesMovieData?(storiesMovieData)
            onDidLoadFavoritesMovieData?(favoritesMovieData)
            onDidLoadAllMovieData?(allMovieData)
            onDidFinishLoad?()
        }
    }
    
    private func notifyLoadingFinish() {
        Task { @MainActor in
            onDidFinishLoad?()
        }
    }
    
    private func fetchStoriesMovieData() async throws -> [StoriesMovieData] {
        let movies = try await getMoviesUseCase.execute()
        return mapToStoriesMovieData(movies)
    }
    
    private func fetchFavoritesMovieData() async throws -> [FavoritesMovieData] {
        let movies = try await getFavoriteMoviesUseCase.execute()
        return mapToFavoritesMovieData(movies)
    }
    
    private func fetchAllMovieData() async throws -> [AllMovieData]? {
        do {
            if let movie = try await getAllMoviesUseCase.execute() {
                return mapToAllMovieData(movie)
            } else {
                return nil
            }
        } catch {
            return nil
        }
    }
    
    private func fetchInitialMovieData() async throws -> [AllMovieData] {
        let movie = try await getAllMoviesUseCase.loadInitialMovies()
        return mapToAllMovieData(movie)
    }
    
    private func mapToStoriesMovieData(_ movies: [MovieElementModel]) -> [StoriesMovieData] {
        return movies.map { movie in
            StoriesMovieData(
                posterURL: movie.poster ?? SC.empty,
                name: movie.name ?? SC.empty,
                genres: movie.genres?.compactMap { $0.name } ?? [],
                id: movie.id
            )
        }
    }
    
    private func mapToFavoritesMovieData(_ movies: [MovieElementModel]) -> [FavoritesMovieData] {
        return movies.map { movie in
            FavoritesMovieData(
                posterURL: movie.poster ?? SC.empty,
                id: movie.id
            )
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
}
