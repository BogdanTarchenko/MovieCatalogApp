//
//  UserRegisterModel.swift
//  MovieCatalogApp
//
//  Created by Богдан Тарченко on 14.10.2024.
//

struct UserRegisterRequestModel: Codable {
    let userName: String
    let name: String
    let password: String
    let email: String
    let birthDate: String
    let gender: Int
}
