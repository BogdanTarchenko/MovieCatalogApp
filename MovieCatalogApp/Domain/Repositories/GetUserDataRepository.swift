//
//  GetUserDataRepository.swift
//  MovieCatalogApp
//
//  Created by Богдан Тарченко on 25.10.2024.
//

protocol GetUserDataRepository {
    func getUserData() async throws -> UserDataResponseModel
}
