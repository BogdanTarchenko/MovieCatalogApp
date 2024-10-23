//
//  LocalizedString.swift
//  MovieCatalogApp
//
//  Created by Богдан Тарченко on 21.10.2024.
//

import Foundation

enum LocalizedString {
    enum Welcome {
        static var welcomeMessage: String {
            return NSLocalizedString("welcome_title", comment: SC.empty)
        }
        
        static var signInButtonTitle: String {
            return NSLocalizedString("welcome_sign_in_button_title", comment: SC.empty)
        }
        
        static var signUpButtonTitle: String {
            return NSLocalizedString("welcome_sign_up_button_title", comment: SC.empty)
        }
    }
    
    enum SignIn {
        static var signInButtonTitle: String {
            return NSLocalizedString("sign_in_button_title", comment: SC.empty)
        }
    }
    
    enum SignUp {
        static var signUpButtonTitle: String {
            return NSLocalizedString("sign_up_button_title", comment: SC.empty)
        }
    }
    
    enum Feed {
        static var emptyMovie: String {
            return NSLocalizedString("empty_movie", comment: SC.empty)
        }
    }
    
    enum TextField {
        static var done: String {
            return NSLocalizedString("done", comment: SC.empty)
        }
    }
    
    enum TabBar {
        static var feed: String {
            return NSLocalizedString("feed", comment: SC.empty)
        }
        
        static var movies: String {
            return NSLocalizedString("movies", comment: SC.empty)
        }
        
        static var favorites: String {
            return NSLocalizedString("favorites", comment: SC.empty)
        }
        
        static var profile: String {
            return NSLocalizedString("profile", comment: SC.empty)
        }
    }
}
