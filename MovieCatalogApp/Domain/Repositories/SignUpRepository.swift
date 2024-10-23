//
//  SignUpRepository.swift
//  MovieCatalogApp
//
//  Created by Богдан Тарченко on 19.10.2024.
//

protocol SignUpRepository {
    func registerUser(request: UserRegisterRequestModel) async throws -> UserAuthResponseModel
    func saveToken(token: String) throws
}
