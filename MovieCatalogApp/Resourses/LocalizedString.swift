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
    
    enum Greeting {
        static var morning: String {
            return NSLocalizedString("morning_greeting", comment: SC.empty)
        }
        
        static var day: String {
            return NSLocalizedString("day_greeting", comment: SC.empty)
        }
        
        static var evening: String {
            return NSLocalizedString("evening_greeting", comment: SC.empty)
        }
        
        static var night: String {
            return NSLocalizedString("night_greeting", comment: SC.empty)
        }
    }
    
    enum Alert {
        static var changeProfileImagePlaceholder: String {
            return NSLocalizedString("profile_image_placeholder", comment: SC.empty)
        }
        
        static var OK: String {
            return NSLocalizedString("alert_ok", comment: SC.empty)
        }
        
        static var cancel: String {
            return NSLocalizedString("alert_cancel", comment: SC.empty)
        }
        
        static var changeProfileImageTitle: String {
            return NSLocalizedString("profile_image_title", comment: SC.empty)
        }
    }
    
    enum Profile {
        static var friends: String {
            return NSLocalizedString("profile_friends", comment: SC.empty)
        }
    }
}
