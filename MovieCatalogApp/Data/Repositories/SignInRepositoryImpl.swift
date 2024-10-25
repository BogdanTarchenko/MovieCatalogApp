//
//  SignInRepositoryImpl.swift
//  MovieCatalogApp
//
//  Created by Богдан Тарченко on 19.10.2024.
//

import KeychainAccess

class SignInRepositoryImpl: SignInRepository {
    private let httpClient: HTTPClient
    private let keychain: Keychain
    
    init(httpClient: HTTPClient, keychain: Keychain) {
        self.httpClient = httpClient
        self.keychain = keychain
    }
    
    func authorizeUser(request: LoginCredentialsRequestModel) async throws -> UserAuthResponseModel {
        let endpoint = UserLoginEndpoint()
        return try await httpClient.sendRequest(endpoint: endpoint, requestBody: request)
    }
    
    func saveToken(token: String) throws {
        try keychain.set(token, key: "authToken2")
    }
}
