//
//  MoviesViewModel.swift
//  MovieCatalogApp
//
//  Created by Богдан Тарченко on 27.10.2024.
//

import Foundation

final class MoviesViewModel {
    
    private let getMoviesUseCase: GetMoviesForStoriesUseCase
    
    var storiesMovieData = [StoriesMovieData]()
    
    var onDidLoadStoriesMovieData: (([StoriesMovieData]) -> Void)?
    var onDidStartLoad: (() -> Void)?
    var onDidFinishLoad: (() -> Void)?
    
    init() {
        self.getMoviesUseCase = GetMoviesForStoriesUseCaseImpl.create()
    }
    
    // MARK: - Public Methods
    func onDidLoad() {
        notifyLoadingStart()
        
        Task {
            do {
                storiesMovieData = try await fetchStoriesMovieData()
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
}
