//
//  DeleteReviewUseCase.swift
//  MovieCatalogApp
//
//  Created by Богдан Тарченко on 03.11.2024.
//

protocol DeleteReviewUseCase {
    func execute(movieID: String, reviewID: String) async throws
}

class DeleteReviewUseCaseImpl: DeleteReviewUseCase {
    private let repository: ReviewsRepository
    
    init(repository: ReviewsRepository) {
        self.repository = repository
    }
    
    static func create() -> DeleteReviewUseCaseImpl {
        let httpClient = AlamofireHTTPClient(baseURL: .kreosoft)
        let repository = ReviewsRepositoryImpl(httpClient: httpClient)
        return DeleteReviewUseCaseImpl(repository: repository)
    }
    
    func execute(movieID: String, reviewID: String) async throws {
        do {
            try await repository.deleteReview(movieID: movieID, reviewID: reviewID)
        } catch {
            throw error
        }
    }
}
