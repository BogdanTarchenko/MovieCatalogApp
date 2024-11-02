//
//  GetPersonByNameEndpoint.swift
//  MovieCatalogApp
//
//  Created by Богдан Тарченко on 02.11.2024.
//

import Alamofire

struct GetPersonByNameEndpoint: APIEndpoint {
    
    let name: String
    
    var path: String {
        let encodedName = name.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? SC.empty
        return "/api/v1/persons?name=\(encodedName)"
    }
    
    var method: Alamofire.HTTPMethod {
        return .get
    }

    var parameters: Alamofire.Parameters? {
        return nil
    }
    
    var headers: Alamofire.HTTPHeaders? {
        return ["X-API-KEY": "9027998c-d612-435a-9768-4cbbb73b7933"]
    }
}
