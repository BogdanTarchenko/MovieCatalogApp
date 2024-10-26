//
//  ChangeUserDataRepository.swift
//  MovieCatalogApp
//
//  Created by Богдан Тарченко on 26.10.2024.
//

protocol ChangeUserDataRepository {
    func changeUserData(request: UserDataRequestModel) async throws
}
