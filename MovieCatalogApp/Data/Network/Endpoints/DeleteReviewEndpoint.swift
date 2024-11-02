//
//  DeleteReviewEndpoint.swift
//  MovieCatalogApp
//
//  Created by Богдан Тарченко on 03.11.2024.
//

import Alamofire
import KeychainAccess

struct DeleteReviewEndpoint: APIEndpoint {
    
    private var authToken: String? {
        let keychain = Keychain()
        return try? keychain.get("authToken2")
    }
    let movieID: String
    let reviewID: String
    
    var path: String {
        return "/api/movie/\(movieID)/review/\(reviewID)/delete"
    }
    
    var method: Alamofire.HTTPMethod {
        return .delete
    }
    
    var parameters: Alamofire.Parameters? {
        return ["id": movieID]
    }
    
    var headers: Alamofire.HTTPHeaders? {
        guard let token = authToken else { return nil }
        return [
            "Authorization": "Bearer \(token)"
        ]
    }
}
