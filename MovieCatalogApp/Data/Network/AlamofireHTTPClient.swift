//
//  AlamofireHTTPClient.swift
//  MovieCatalogApp
//
//  Created by Богдан Тарченко on 15.10.2024.
//

import Alamofire
import KeychainAccess
import Foundation

final class AlamofireHTTPClient: HTTPClient {
    
    private let baseURL: BaseURL
    let keychain = Keychain()
    
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
                .response() { response in
                    self.log(response)
                }
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
    
    func sendRequestWithoutResponse<U: Encodable>(endpoint: APIEndpoint, requestBody: U? = nil) async throws {
        let url = baseURL.baseURL + endpoint.path
        let method = endpoint.method
        let headers = endpoint.headers
        
        return try await withCheckedThrowingContinuation { continuation in
            AF.request(url, method: method, parameters: requestBody, encoder: JSONParameterEncoder.default, headers: headers)
                .validate()
                .response { response in
                    switch response.result {
                    case .success:
                        continuation.resume()
                    case .failure(let error):
                        if let statusCode = response.response?.statusCode, statusCode == 401 {
                            do {
                                try self.keychain.remove("authToken2")
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

// MARK: Requests logging
private extension AlamofireHTTPClient {
    func log(_ response: AFDataResponse<Data?>) {
        print("---------------------------------------------------------------------------------------")
        print("\(response.request?.method?.rawValue ?? SC.empty) \(response.request?.url?.absoluteString ?? SC.empty)")
        print("---------------------------------------------------------------------------------------")
        
        switch response.result {
            
        case let .success(responseData):
            if let object = try? JSONSerialization.jsonObject(with: responseData ?? .empty),
               let data = try? JSONSerialization.data(withJSONObject: object, options: [.prettyPrinted]),
               let string = NSString(data: data, encoding: String.Encoding.utf8.rawValue) {
                print(string)
            }
        case let .failure(error):
            print(error)
        }
        print("---------------------------------------------------------------------------------------")
    }
}
