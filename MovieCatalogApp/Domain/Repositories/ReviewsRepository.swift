//
//  ReviewsRepository.swift
//  MovieCatalogApp
//
//  Created by Богдан Тарченко on 03.11.2024.
//

protocol ReviewsRepository {
    func addReview(movieID: String) async throws
    func editReview(movieID: String, reviewID: String) async throws
    func deleteReview(movieID: String, reviewID: String) async throws
}
