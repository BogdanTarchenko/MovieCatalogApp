//
//  LogoutRepositoryImpl.swift
//  MovieCatalogApp
//
//  Created by Богдан Тарченко on 25.10.2024.
//

import KeychainAccess

class LogoutRepositoryImpl: LogoutRepository {
    private let httpClient: HTTPClient
    private let keychain: Keychain
    
    init(httpClient: HTTPClient, keychain: Keychain) {
        self.httpClient = httpClient
        self.keychain = keychain
    }
    
    func logout() async throws -> UserAuthResponseModel {
        let endpoint = LogoutEndpoint()
        return try await httpClient.sendRequest(endpoint: endpoint, requestBody: nil as EmptyRequestModel?)
    }
    
    func removeToken() throws {
        try keychain.remove("authToken")
    }
}
