//
//  UserDataEndpoint.swift
//  MovieCatalogApp
//
//  Created by Богдан Тарченко on 25.10.2024.
//

import Alamofire
import KeychainAccess

struct UserDataEndpoint: APIEndpoint {
    
    private var authToken: String? {
        let keychain = Keychain()
        return try? keychain.get("authToken2")
    }
    
    var path: String {
        return "/api/account/profile"
    }
    
    var method: Alamofire.HTTPMethod {
        return .get
    }
    
    var parameters: Alamofire.Parameters? {
        return nil
    }
    
    var headers: Alamofire.HTTPHeaders? {
        guard let token = authToken else { return nil }
        return [
            "Authorization": "Bearer \(token)"
        ]
    }
}
