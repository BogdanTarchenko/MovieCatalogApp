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
    @Published var personData = PersonDetails()
    @Published var currentUserId: String = SC.empty
    
    private let getMovieDetailsUseCase: GetMovieDetailsUseCase
    private let getFavoriteMoviesUseCase: GetFavoriteMoviesUseCase
    private let addMovieToFavoritesUseCase: AddMovieToFavoritesUseCase
    private let deleteMovieFromFavoritesUseCase: DeleteMovieFromFavoritesUseCase
    private let getKinopoiskDetailsUseCase: GetKinopoiskDetailsUseCase
    private let getPersonDetailsUseCase: GetPersonByNameUseCase
    private let addReviewUseCase: AddReviewUseCase
    private let editReviewUseCase: EditReviewUseCase
    private let deleteReviewUseCase: DeleteReviewUseCase
    private let getUserProfileUseCase: GetUserDataUseCase
    
    var onDidLoadMovieDetails: ((MovieDetails) -> Void)?
    var onDidLoadKinopoiskDetails: ((KinopoiskDetails) -> Void)?
    var onDidLoadPersonDetails: ((PersonDetails) -> Void)?
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
        self.getPersonDetailsUseCase = GetPersonByNameUseCaseImpl.create()
        self.addReviewUseCase = AddReviewUseCaseImpl.create()
        self.editReviewUseCase = EditReviewUseCaseImpl.create()
        self.deleteReviewUseCase = DeleteReviewUseCaseImpl.create()
        self.getUserProfileUseCase = GetUserDataUseCaseImpl.create()
        
        onDidLoad()
    }
    
    func onDidLoad() {
        notifyLoadingStart()
        
        Task {
            do {
                async let movieDetailsResult = fetchMovieDetails(movieID: movieID)
                async let favoritesMovieDataResult = fetchFavoritesMovieData()
                async let profileResult = getUserProfileUseCase.execute()
                
                let details = try await movieDetailsResult
                let favorites = try await favoritesMovieDataResult
                let profile = try await profileResult
                
                let kinopoiskDetails = try await fetchKinopoiskDetails(yearFrom: details.year, yearTo: details.year, keyword: details.name)
                
                let singleDirector: String
                if let firstCommaIndex = details.director.firstIndex(of: ",") {
                    singleDirector = String(details.director[..<firstCommaIndex]).trimmingCharacters(in: .whitespaces)
                } else {
                    singleDirector = details.director.trimmingCharacters(in: .whitespaces)
                }
                let personDetails = try await fetchPersonDetails(name: singleDirector)
                
                await MainActor.run {
                    self.favoritesMovieData = favorites
                    self.isFavorite = favorites.contains { $0.id == movieID }
                    self.movieDetails = details
                    self.kinopoiskData = kinopoiskDetails
                    self.personData = personDetails
                    self.currentUserId = profile.id
                    
                    Task { @MainActor in
                        onDidLoadKinopoiskDetails?(kinopoiskData)
                    }
                    
                    Task { @MainActor in
                        onDidLoadPersonDetails?(personDetails)
                    }
                    
                    notifyMovieDetailsLoaded(details)
                    
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
    
    func addReview(request: ReviewRequest) async throws {
        try await addReviewUseCase.execute(movieID: movieID, request: request)
    }

    
    func editReview(reviewID: String, request: ReviewRequest) async throws {
        try await editReviewUseCase.execute(movieID: movieID, reviewID: reviewID, request: request)
    }
    
    func deleteReview(reviewID: String) async throws {
        try await deleteReviewUseCase.execute(movieID: movieID, reviewID: reviewID)
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
    
    func fetchMovieDetails(movieID: String) async throws -> MovieDetails {
        let movie = try await getMovieDetailsUseCase.execute(movieID: movieID)
        return mapToMovieDetails(movie)
    }
    
    private func fetchKinopoiskDetails(yearFrom: Int, yearTo: Int, keyword: String) async throws -> KinopoiskDetails {
        let movie = try await getKinopoiskDetailsUseCase.execute(yearFrom: yearFrom, yearTo: yearTo, keyword: keyword)
        return mapToKinopoiskDetails(movie)
    }
    
    private func fetchPersonDetails(name: String) async throws -> PersonDetails {
        let person = try await getPersonDetailsUseCase.execute(name: name)
        return mapToPersonDetails(person)
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
        let genres: [GenreDetails] = movie.genres?.compactMap { genre in
            guard let genre = genre else { return nil }
            return GenreDetails(id: genre.id, name: genre.name ?? SC.empty)
        } ?? []
        
        let reviews: [ReviewDetails] = movie.reviews?.compactMap { review in
            guard let review = review else { return nil }
            return ReviewDetails(
                id: review.id,
                rating: review.rating,
                reviewText: review.reviewText ?? SC.empty,
                isAnonymous: review.isAnonymous,
                createDateTime: review.createDateTime,
                author: AuthorDetails(
                    userId: review.author?.userId ?? SC.empty,
                    nickName: review.author?.nickName ?? Constants.anonymusUser,
                    avatar: review.author?.avatar ?? Constants.avatarLink
                )
            )
        } ?? []
        
        return MovieDetails(
            id: movie.id,
            name: movie.name ?? SC.empty,
            poster: movie.poster ?? SC.empty,
            year: movie.year,
            country: movie.country ?? SC.empty,
            genres: genres,
            reviews: reviews,
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
    
    private func mapToPersonDetails(_ person: PersonByNameResponse) -> PersonDetails {
        return PersonDetails(
            posterURL: person.items.first?.posterUrl ?? SC.empty
        )
    }
}

extension MovieDetailsViewModel {
    enum Constants {
        static var avatarLink: String = "https://s3-alpha-sig.figma.com/img/a92b/ba97/a13937d71ea4ab29b068a92fd325aa74?Expires=1731283200&Key-Pair-Id=APKAQ4GOSFWCVNEHN3O4&Signature=NChlGzcfGZDhcEKxSkCuF2s07eic2KBzFrFDqDNR-cLTSRdLnoGdp3lgKFZJ70jgBCxUWz6J7LE~nBKRbeBagiPAx6PEpRfiaTPv5B5YMnrjkP3m9OshStQuDb7LJyufIqH1swKkFOywX7Wo3uEwUtueMagv6J~UzRAPWoxqvgJaRbi2uET-TmmLY4bCcB8tqfvPaCrjKm0ajPGWlpP7TzTfEuZbulvT2MgKpg5taY4z-iXg6Mrww8Xge05ioMU5V4raAnRNpOgFyRGbq3ZZkT1LsKjQ4HLyLWxycmaukA1zWwLcm7OfsDlOx~OB3Uwkl04nTnIxe8NfaOEwQSb1FQ__"
        
        static var anonymusUser: String = LocalizedString.MovieDetails.Reviews.anonymusUser
    }
}
