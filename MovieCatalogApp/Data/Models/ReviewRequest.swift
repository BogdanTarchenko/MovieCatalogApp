//
//  ReviewRequest.swift
//  MovieCatalogApp
//
//  Created by Богдан Тарченко on 03.11.2024.
//

struct ReviewRequest: Codable {
    let reviewText: String
    let rating: Int
    let isAnonymous: Bool
}
