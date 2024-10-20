//
//  SignInUseCase.swift
//  MovieCatalogApp
//
//  Created by Богдан Тарченко on 19.10.2024.
//

import KeychainAccess

protocol SignInUseCase {
    func execute(request: LoginCredentialsRequestModel, completion: @escaping (Result<Void, Error>) -> Void)
}

class SignInUseCaseImpl: SignInUseCase {
    private let repository: SignInRepository
    
    init(repository: SignInRepository) {
        self.repository = repository
    }
    
    static func create() -> SignInUseCaseImpl {
        let httpClient = AlamofireHTTPClient(baseURL: .kreosoft)
        let keychain = Keychain()
        let repository = SignInRepositoryImpl(httpClient: httpClient, keychain: keychain)
        return SignInUseCaseImpl(repository: repository)
    }
    
    func execute(request: LoginCredentialsRequestModel, completion: @escaping (Result<Void, Error>) -> Void) {
        repository.authorizeUser(request: request) { result in
            switch result {
            case .success(let response):
                do {
                    try self.repository.saveToken(token: response.token)
                    completion(.success(()))
                } catch {
                    completion(.failure(error))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
