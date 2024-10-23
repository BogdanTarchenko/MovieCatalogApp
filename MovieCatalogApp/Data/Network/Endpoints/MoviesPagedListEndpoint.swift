//
//  MoviesPagedListEndpoint.swift
//  MovieCatalogApp
//
//  Created by Богдан Тарченко on 20.10.2024.
//

import Alamofire

struct MoviesPagedListEndpoint: APIEndpoint {
    let page: Int
    
    var path: String {
        return "/api/movies/\(page)"
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
