//
//  ChangeUserDataUseCase.swift
//  MovieCatalogApp
//
//  Created by Богдан Тарченко on 26.10.2024.
//

protocol ChangeUserDataUseCase {
    func execute(request: UserDataRequestModel) async throws
}

class ChangeUserDataUseCaseImpl: ChangeUserDataUseCase {
    private let repository: ChangeUserDataRepository
    
    init(repository: ChangeUserDataRepository) {
        self.repository = repository
    }
    
    static func create() -> ChangeUserDataUseCaseImpl {
        let httpClient = AlamofireHTTPClient(baseURL: .kreosoft)
        let repository = ChangeUserDataRepositoryImpl(httpClient: httpClient)
        return ChangeUserDataUseCaseImpl(repository: repository)
    }
    
    func execute(request: UserDataRequestModel) async throws {
        do {
            try await repository.changeUserData(request: request)
        } catch {
            throw error
        }
    }
}
