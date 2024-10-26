//
//  LogoutUseCase.swift
//  MovieCatalogApp
//
//  Created by Богдан Тарченко on 25.10.2024.
//

import KeychainAccess

protocol LogoutUseCase {
    func execute() async throws
}

class LogoutUseCaseImpl: LogoutUseCase {
    private let repository: LogoutRepository
    
    init(repository: LogoutRepository) {
        self.repository = repository
    }
    
    static func create() -> LogoutUseCaseImpl {
        let httpClient = AlamofireHTTPClient(baseURL: .kreosoft)
        let keychain = Keychain()
        let repository = LogoutRepositoryImpl(httpClient: httpClient, keychain: keychain)
        return LogoutUseCaseImpl(repository: repository)
    }
    
    func execute() async throws {
        do {
            let response = try await repository.logout()
            try repository.removeToken()
        } catch {
            throw error
        }
    }
}
