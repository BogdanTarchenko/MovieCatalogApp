//
//  UserDataChangeEndpoint.swift
//  MovieCatalogApp
//
//  Created by Богдан Тарченко on 26.10.2024.
//

import Alamofire
import KeychainAccess

struct UserDataChangeEndpoint: APIEndpoint {
    
    private var authToken: String? {
        let keychain = Keychain()
        return try? keychain.get("authToken2")
    }
    
    var path: String {
        return "/api/account/profile"
    }
    
    var method: Alamofire.HTTPMethod {
        return .put
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
