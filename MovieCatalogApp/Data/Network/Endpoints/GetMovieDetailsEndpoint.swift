//
//  GetMovieDetailsEndpoint.swift
//  MovieCatalogApp
//
//  Created by Богдан Тарченко on 01.11.2024.
//

import Alamofire
import KeychainAccess

struct GetMovieDetailsEndpoint: APIEndpoint {
    
    let movieID: String
    
    var path: String {
        return "/api/movies/details/\(movieID)"
    }
    
    var method: Alamofire.HTTPMethod {
        return .get
    }
    
    var parameters: Alamofire.Parameters? {
        return ["id": movieID]
    }
    
    var headers: Alamofire.HTTPHeaders? {
        return nil
    }
}
