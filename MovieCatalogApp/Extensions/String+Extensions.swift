//
//  String+Extensions.swift
//  MovieCatalogApp
//
//  Created by Богдан Тарченко on 15.10.2024.
//

import Foundation

extension String {
    var isValidEmail: Bool {
        let regularExpression = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let predicate = NSPredicate(format: "SELF MATCHES %@", regularExpression)
        return predicate.evaluate(with: self)
    }
    
    var isValidPassword: Bool {
        let regularExpression = "(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[#?!@$ %^&*-]).{6,}"
        let predicate = NSPredicate(format: "SELF MATCHES %@", regularExpression)
        return predicate.evaluate(with: self)
    }
}

extension String {
    static var empty: String {
        return SC.empty
    }
    
    static var space: String {
        return SC.space
    }
    
    static var dash: String {
        return SC.dash
    }
}

typealias SC = StringConstants
enum StringConstants {
    
    static let empty = ""
    static let space = " "
    static let dash = "-"
}
