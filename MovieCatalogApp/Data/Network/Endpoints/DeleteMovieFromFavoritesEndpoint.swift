//
//  DeleteMovieFromFavoritesEndpoint.swift
//  MovieCatalogApp
//
//  Created by Богдан Тарченко on 31.10.2024.
//

import Alamofire
import KeychainAccess

struct DeleteMovieFromFavoritesEndpoint: APIEndpoint {
    
    let movieID: String
    
    private var authToken: String? {
        let keychain = Keychain()
        return try? keychain.get("authToken")
    }
    
    var path: String {
        return "/api/favorites/\(movieID)/delete"
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
