//
//  ReviewsRepositoryImpl.swift
//  MovieCatalogApp
//
//  Created by Богдан Тарченко on 03.11.2024.
//

class ReviewsRepositoryImpl: ReviewsRepository {
    private let httpClient: HTTPClient
    
    init(httpClient: HTTPClient) {
        self.httpClient = httpClient
    }
    
    func addReview(movieID: String) async throws {
        let endpoint = AddReviewEndpoint(movieID: movieID)
        try await httpClient.sendRequestWithoutResponse(endpoint: endpoint, requestBody: nil as EmptyRequestModel?)
    }
    
    func editReview(movieID: String, reviewID: String) async throws {
        let endpoint = EditReviewEndpoint(movieID: movieID, reviewID: reviewID)
        try await httpClient.sendRequestWithoutResponse(endpoint: endpoint, requestBody: nil as EmptyRequestModel?)
    }
    
    func deleteReview(movieID: String, reviewID: String) async throws {
        let endpoint = DeleteReviewEndpoint(movieID: movieID, reviewID: reviewID)
        try await httpClient.sendRequestWithoutResponse(endpoint: endpoint, requestBody: nil as EmptyRequestModel?)
    }
}
