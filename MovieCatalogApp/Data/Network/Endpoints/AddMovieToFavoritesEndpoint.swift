//
//  AddMovieToFavoritesEndpoint.swift
//  MovieCatalogApp
//
//  Created by Богдан Тарченко on 28.10.2024.
//

import Alamofire
import KeychainAccess

struct AddMovieToFavoritesEndpoint: APIEndpoint {
    
    private var authToken: String? {
        let keychain = Keychain()
        return try? keychain.get("authToken2")
    }
    
    var path: String {
        return "/api/account/profile"
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
    
    private let movieID: String
    
    init(movieID: String) {
        self.movieID = movieID
    }
}
