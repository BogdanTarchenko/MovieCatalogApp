//
//  SignUpRepository.swift
//  MovieCatalogApp
//
//  Created by Богдан Тарченко on 19.10.2024.
//

protocol SignUpRepository {
    func registerUser(request: UserRegisterRequestModel, completion: @escaping (Result<UserAuthResponseModel, Error>) -> Void)
    func saveToken(token: String) throws
}
