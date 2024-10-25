//
//  UserDataResponseModel.swift
//  MovieCatalogApp
//
//  Created by Богдан Тарченко on 25.10.2024.
//

struct UserDataResponseModel: Codable {
    let id: String
    let nickName: String
    let email: String
    let avatarLink: String?
    let name: String
    let birthDate: String
    let gender: Int
}
