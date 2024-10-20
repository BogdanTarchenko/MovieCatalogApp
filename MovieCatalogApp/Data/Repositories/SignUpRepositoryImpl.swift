//
//  SignUpRepositoryImpl.swift
//  MovieCatalogApp
//
//  Created by Богдан Тарченко on 19.10.2024.
//

import KeychainAccess

class SignUpRepositoryImpl: SignUpRepository {
    private let httpClient: HTTPClient
    private let keychain: Keychain
    
    init(httpClient: HTTPClient, keychain: Keychain) {
        self.httpClient = httpClient
        self.keychain = keychain
    }
    
    func registerUser(request: UserRegisterRequestModel, completion: @escaping (Result<UserAuthResponseModel, Error>) -> Void) {
        let endpoint = UserRegisterEndpoint()
        httpClient.sendRequest(endpoint: endpoint, requestBody: request, completion: completion)
    }
    
    func saveToken(token: String) throws {
        try keychain.set(token, key: "authToken")
    }
}
