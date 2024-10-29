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
    
    var storiesMovieData = [StoriesMovieData]()
    var favoritesMovieData = [FavoritesMovieData]()
    
    var onDidLoadStoriesMovieData: (([StoriesMovieData]) -> Void)?
    var onDidLoadFavoritesMovieData: (([FavoritesMovieData]) -> Void)?
    var onDidStartLoad: (() -> Void)?
    var onDidFinishLoad: (() -> Void)?
    
    init() {
        self.getMoviesUseCase = GetMoviesForStoriesUseCaseImpl.create()
        self.getFavoriteMoviesUseCase = GetFavoriteMoviesUseCaseImpl.create()
    }
    
    // MARK: - Public Methods
    func onDidLoad() {
        notifyLoadingStart()
        
        Task {
            do {
                async let storiesMovieDataResult = try await fetchStoriesMovieData()
                async let favoritesMovieDataResult = try await fetchFavoritesMovieData()
                
                (storiesMovieData, favoritesMovieData) = await (try storiesMovieDataResult, try favoritesMovieDataResult)
                
                notifyLoadingSuccess()
            } catch {
                notifyLoadingFinish()
            }
        }
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
}
