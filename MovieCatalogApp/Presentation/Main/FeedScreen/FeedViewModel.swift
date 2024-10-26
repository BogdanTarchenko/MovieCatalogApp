//
//  FeedViewModel.swift
//  MovieCatalogApp
//
//  Created by Богдан Тарченко on 20.10.2024.
//

import Foundation

final class FeedViewModel {
    
    weak var appRouterDelegate: AppRouterDelegate?
    
    private let getMoviesUseCase: GetMoviesUseCase
    
    var currentMovieData = FeedMovieData()
    var nextMovieData = FeedMovieData()
    
    init() {
        self.getMoviesUseCase = GetMoviesUseCaseImpl.create()
    }
    
    func loadInitialMovies() async {
        if let movieData = await fetchNextMovie() {
            currentMovieData = movieData
            NotificationCenter.default.post(name: .didLoadMovies, object: nil)
        }
        
        if let movieData = await fetchNextMovie() {
            nextMovieData = movieData
        }
    }
    
    func fetchNextMovie() async -> FeedMovieData? {
        do {
            if let movie = try await getMoviesUseCase.execute() {
                return mapToFeedMovieData(movie)
            } else {
                return nil
            }
        } catch {
            print("Ошибка загрузки филмьа: \(error)")
            return nil
        }
    }
    
    private func mapToFeedMovieData(_ movie: MovieElementModel) -> FeedMovieData {
        return FeedMovieData(
            posterURL: movie.poster ?? SC.empty,
            name: movie.name ?? SC.empty,
            year: movie.year,
            country: movie.country ?? SC.empty,
            genres: movie.genres?.compactMap { $0.name } ?? [],
            id: movie.id
        )
    }
}

extension Notification.Name {
    static let didLoadMovies = Notification.Name("didLoadMovies")
}
