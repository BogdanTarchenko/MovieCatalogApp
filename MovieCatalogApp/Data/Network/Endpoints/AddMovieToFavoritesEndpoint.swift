//
//  AddMovieToFavoritesEndpoint.swift
//  MovieCatalogApp
//
//  Created by Богдан Тарченко on 28.10.2024.
//

import Alamofire
import KeychainAccess

struct AddMovieToFavoritesEndpoint: APIEndpoint {
    
    let movieID: String
    
    private var authToken: String? {
        let keychain = Keychain()
        return try? keychain.get("authToken2")
    }
    
    var path: String {
        return "/api/favorites/\(movieID)/add"
    }
    
    var method: Alamofire.HTTPMethod {
        return .post
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
