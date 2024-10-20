//
//  AlamofireHTTPClient.swift
//  MovieCatalogApp
//
//  Created by Богдан Тарченко on 15.10.2024.
//

import Alamofire

final class AlamofireHTTPClient: HTTPClient {
    
    private let baseURL: BaseURL

    init(baseURL: BaseURL) {
        self.baseURL = baseURL
    }

    func sendRequest<T: Decodable, U: Encodable>(endpoint: APIEndpoint, requestBody: U?, completion: @escaping (Result<T, Error>) -> Void) {
        let url = baseURL.baseURL + endpoint.path
        let method = endpoint.method
        let headers = endpoint.headers
        
        AF.request(url, method: method, parameters: requestBody, encoder: JSONParameterEncoder.default, headers: headers)
            .validate()
            .responseDecodable(of: T.self) { response in
                switch response.result {
                case .success(let decodedData):
                    completion(.success(decodedData))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
    }
}
