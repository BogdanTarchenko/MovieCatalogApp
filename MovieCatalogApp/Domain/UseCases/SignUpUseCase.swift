//
//  SignUpUseCase.swift
//  MovieCatalogApp
//
//  Created by Богдан Тарченко on 19.10.2024.
//

import KeychainAccess

protocol SignUpUseCase {
    func execute(request: UserRegisterRequestModel) async throws
}

class SignUpUseCaseImpl: SignUpUseCase {
    private let repository: SignUpRepository
    
    init(repository: SignUpRepository) {
        self.repository = repository
    }
    
    static func create() -> SignUpUseCaseImpl {
        let httpClient = AlamofireHTTPClient(baseURL: .kreosoft)
        let keychain = Keychain()
        let repository = SignUpRepositoryImpl(httpClient: httpClient, keychain: keychain)
        return SignUpUseCaseImpl(repository: repository)
    }
    
    func execute(request: UserRegisterRequestModel) async throws {
        do {
            let response = try await repository.registerUser(request: request)
            try repository.saveToken(token: response.token)
        } catch {
            throw error
        }
    }
}
