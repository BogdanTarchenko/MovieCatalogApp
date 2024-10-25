//
//  UserDataEndpoint.swift
//  MovieCatalogApp
//
//  Created by Богдан Тарченко on 25.10.2024.
//

import Alamofire

struct UserDataEndpoint: APIEndpoint {
    
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
        return nil
    }
}
