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
    
    private let getMovieDetailsUseCase: GetMovieDetailsUseCase
    
    init(movieID: String) {
        self.movieID = movieID
        self.getMovieDetailsUseCase = GetMovieDetailsUseCaseImpl.create()
    }
    
    private func mapToMovieDetails(_ movie: MovieDetailsModel) -> MovieDetails {
        return MovieDetails(
            id: movie.id,
            name: movie.name ?? SC.empty,
            poster: movie.poster ?? SC.empty,
            year: movie.year,
            country: movie.country ?? SC.empty,
            genres: movie.genres.map { GenreDetails(id: $0.id, name: $0.name ?? SC.empty) },
            reviews: movie.reviews.map { ReviewDetails(id: $0.id, rating: $0.rating, reviewText: $0.reviewText ?? SC.empty, isAnonymous: $0.isAnonymous, createDateTime: $0.createDateTime, author: AuthorDetails(userId: $0.author.userId, nickName: $0.author.nickName ?? SC.empty, avatar: $0.author.avatar ?? SC.empty)) },
            time: movie.time,
            tagline: movie.tagline ?? SC.empty,
            description: movie.description ?? SC.empty,
            director: movie.director ?? SC.empty,
            budget: movie.budget ?? 0,
            fees: movie.fees ?? 0,
            ageLimit: movie.ageLimit
        )
    }
}
