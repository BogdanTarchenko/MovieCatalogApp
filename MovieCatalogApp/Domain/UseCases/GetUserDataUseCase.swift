//
//  GetUserDataUseCase.swift
//  MovieCatalogApp
//
//  Created by Богдан Тарченко on 25.10.2024.
//

protocol GetUserDataUseCase {
    func execute() async throws -> UserDataResponseModel
}

class GetUserDataUseCaseImpl: GetUserDataUseCase {
    private let repository: GetUserDataRepository
    
    init(repository: GetUserDataRepository) {
        self.repository = repository
    }
    
    static func create() -> GetUserDataUseCaseImpl {
        let httpClient = AlamofireHTTPClient(baseURL: .kreosoft)
        let repository = GetUserDataRepositoryImpl(httpClient: httpClient)
        return GetUserDataUseCaseImpl(repository: repository)
    }
    
    func execute() async throws -> UserDataResponseModel {
        do {
            let response = try await repository.getUserData()
            return response
        } catch {
            throw error
        }
    }
}
