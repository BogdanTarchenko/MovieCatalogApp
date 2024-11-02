//
//  AddReviewUseCase.swift
//  MovieCatalogApp
//
//  Created by Богдан Тарченко on 03.11.2024.
//

protocol AddReviewUseCase {
    func execute(movieID: String) async throws
}

class AddReviewUseCaseImpl: AddReviewUseCase {
    private let repository: ReviewsRepository
    
    init(repository: ReviewsRepository) {
        self.repository = repository
    }
    
    static func create() -> AddReviewUseCaseImpl {
        let httpClient = AlamofireHTTPClient(baseURL: .kreosoft)
        let repository = ReviewsRepositoryImpl(httpClient: httpClient)
        return AddReviewUseCaseImpl(repository: repository)
    }
    
    func execute(movieID: String) async throws {
        do {
            try await repository.addReview(movieID: movieID)
        } catch {
            throw error
        }
    }
}
