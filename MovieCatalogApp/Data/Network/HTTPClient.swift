//
//  HTTPClient.swift
//  MovieCatalogApp
//
//  Created by Богдан Тарченко on 15.10.2024.
//

protocol HTTPClient {
    func sendRequest<T: Decodable, U: Encodable>(endpoint: APIEndpoint, requestBody: U?) async throws -> T
    func sendRequestWithoutResponse<U: Encodable>(endpoint: APIEndpoint, requestBody: U?) async throws
}
