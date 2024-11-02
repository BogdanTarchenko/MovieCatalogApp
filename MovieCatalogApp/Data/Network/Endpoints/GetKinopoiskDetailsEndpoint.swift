//
//  GetKinopoiskDetails.swift
//  MovieCatalogApp
//
//  Created by Богдан Тарченко on 02.11.2024.
//

import Alamofire

struct GetKinopoiskDetailsEndpoint: APIEndpoint {
    
    let yearFrom: Int
    let yearTo: Int
    let keyword: String
    
    var path: String {
        let encodedKeyword = keyword.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        return "/api/v2.2/films?yearFrom=\(yearFrom)&yearTo=\(yearTo)&keyword=\(encodedKeyword)"
    }
    
    var method: Alamofire.HTTPMethod {
        return .get
    }

    var parameters: Alamofire.Parameters? {
        return nil
    }
    
    var headers: Alamofire.HTTPHeaders? {
        return ["X-API-KEY": "bd433242-6b95-4ee8-a05d-deb59acfa719"]
    }
}
