//
//  LogoutRepository.swift
//  MovieCatalogApp
//
//  Created by Богдан Тарченко on 25.10.2024.
//

protocol LogoutRepository {
    func logout() async throws -> UserAuthResponseModel
    func removeToken() throws
}
