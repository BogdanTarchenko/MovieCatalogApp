//
//  EditReviewUseCase.swift
//  MovieCatalogApp
//
//  Created by Богдан Тарченко on 03.11.2024.
//

protocol EditReviewUseCase {
    func execute(movieID: String, reviewID: String, request: ReviewRequest) async throws
}

class EditReviewUseCaseImpl: EditReviewUseCase {
    private let repository: ReviewsRepository
    
    init(repository: ReviewsRepository) {
        self.repository = repository
    }
    
    static func create() -> EditReviewUseCaseImpl {
        let httpClient = AlamofireHTTPClient(baseURL: .kreosoft)
        let repository = ReviewsRepositoryImpl(httpClient: httpClient)
        return EditReviewUseCaseImpl(repository: repository)
    }
    
    func execute(movieID: String, reviewID: String, request: ReviewRequest) async throws {
        do {
            try await repository.editReview(movieID: movieID, reviewID: reviewID, request: request)
        } catch {
            throw error
        }
    }
}
