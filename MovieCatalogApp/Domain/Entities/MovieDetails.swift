//
//  MovieDetails.swift
//  MovieCatalogApp
//
//  Created by Богдан Тарченко on 31.10.2024.
//

import Foundation

struct MovieDetails {
    let id: String
    let name: String
    let poster: String
    let year: Int
    let country: String
    let genres: [GenreDetails]
    let reviews: [ReviewDetails]
    let time: Int
    let tagline: String
    let description: String
    let director: String
    let budget: Int
    let fees: Int
    let ageLimit: Int
}

struct GenreDetails {
    let id: String
    let name: String
}

struct ReviewDetails {
    let id: String
    let rating: Int
    let reviewText: String
    let isAnonymous: Bool
    let createDateTime: Date
    let author: AuthorDetails
}

struct AuthorDetails {
    let userId: String
    let nickName: String
    let avatar: String
}
