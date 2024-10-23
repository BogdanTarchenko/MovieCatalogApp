//
//  SignInRepository.swift
//  MovieCatalogApp
//
//  Created by Богдан Тарченко on 19.10.2024.
//

protocol SignInRepository {
    func authorizeUser(request: LoginCredentialsRequestModel) async throws -> UserAuthResponseModel
    func saveToken(token: String) throws
}
