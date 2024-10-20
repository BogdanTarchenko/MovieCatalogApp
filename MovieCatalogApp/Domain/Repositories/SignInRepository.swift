//
//  SignInRepository.swift
//  MovieCatalogApp
//
//  Created by Богдан Тарченко on 19.10.2024.
//

protocol SignInRepository {
    func authorizeUser(request: LoginCredentialsRequestModel, completion: @escaping (Result<UserAuthResponseModel, Error>) -> Void)
    func saveToken(token: String) throws
}
