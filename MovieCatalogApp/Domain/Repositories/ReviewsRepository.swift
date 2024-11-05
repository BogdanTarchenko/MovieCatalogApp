//
//  ReviewsRepository.swift
//  MovieCatalogApp
//
//  Created by Богдан Тарченко on 03.11.2024.
//

protocol ReviewsRepository {
    func add(movieID: String, request: ReviewRequest) async throws
    func edit(movieID: String, reviewID: String, request: ReviewRequest) async throws
    func delete(movieID: String, reviewID: String) async throws
}
