//
//  AlamofireHTTPClient.swift
//  MovieCatalogApp
//
//  Created by Богдан Тарченко on 15.10.2024.
//

import Alamofire
import KeychainAccess

final class AlamofireHTTPClient: HTTPClient {
    
    private let baseURL: BaseURL
    
    init(baseURL: BaseURL) {
        self.baseURL = baseURL
    }
    
    func sendRequest<T: Decodable, U: Encodable>(endpoint: APIEndpoint, requestBody: U? = nil) async throws -> T {
        let url = baseURL.baseURL + endpoint.path
        let method = endpoint.method
        let headers = endpoint.headers
        
        return try await withCheckedThrowingContinuation { continuation in
            AF.request(url, method: method, parameters: requestBody, encoder: JSONParameterEncoder.default, headers: headers)
                .validate()
                .responseDecodable(of: T.self) { response in
                    switch response.result {
                    case .success(let decodedData):
                        continuation.resume(returning: decodedData)
                    case .failure(let error):
                        if let statusCode = response.response?.statusCode, statusCode == 401 {
                            do {
                                let keychain = Keychain()
                                try keychain.remove("authToken2")
                            } catch {
                                print("Ошибка удаления токена: \(error)")
                            }
                        }
                        continuation.resume(throwing: error)
                    }
                }
        }
    }
}
