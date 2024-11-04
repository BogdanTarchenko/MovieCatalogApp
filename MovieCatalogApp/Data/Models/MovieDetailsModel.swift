//
//  MovieDetailsModel.swift
//  MovieCatalogApp
//
//  Created by Богдан Тарченко on 31.10.2024.
//

import Foundation

struct MovieDetailsModel: Codable {
    let id: String
    let name: String?
    let poster: String?
    let year: Int
    let country: String?
    let genres: [Genre?]?
    let reviews: [ReviewModel?]?
    let time: Int
    let tagline: String?
    let description: String?
    let director: String?
    let budget: Int?
    let fees: Int?
    let ageLimit: Int
}

struct Genre: Codable {
    let id: String
    let name: String?
}

struct ReviewModel: Codable {
    let id: String
    let rating: Int
    let reviewText: String?
    let isAnonymous: Bool
    let createDateTime: String
    let author: Author?
}

struct Author: Codable {
    let userId: String
    let nickName: String?
    let avatar: String?
}
