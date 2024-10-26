//
//  ChangeUserDataRepositoryImpl.swift
//  MovieCatalogApp
//
//  Created by Богдан Тарченко on 26.10.2024.
//

class ChangeUserDataRepositoryImpl: ChangeUserDataRepository {
    private let httpClient: HTTPClient
    
    init(httpClient: HTTPClient) {
        self.httpClient = httpClient
    }
    
    func changeUserData(request: UserDataRequestModel) async throws {
        let endpoint = UserDataChangeEndpoint()
        try await httpClient.sendRequestWithoutResponse(endpoint: endpoint, requestBody: request)
    }
}
