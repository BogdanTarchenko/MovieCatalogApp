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
        
        static var privateInformationLabel: String {
            return NSLocalizedString("private_information_label", comment: SC.empty)
        }
        
        static var usernameTitle: String {
            return NSLocalizedString("profile_username_title", comment: SC.empty)
        }
        
        static var emailTitle: String {
            return NSLocalizedString("profile_email_title", comment: SC.empty)
        }
        
        static var nameTitle: String {
            return NSLocalizedString("profile_name_title", comment: SC.empty)
        }
        
        static var birthDateTitle: String {
            return NSLocalizedString("profile_birthDate_title", comment: SC.empty)
        }
        
        static var genderTitle: String {
            return NSLocalizedString("profile_gender_title", comment: SC.empty)
        }
    }
    
    enum Movies {
        static var watchButtonTitle: String {
            return NSLocalizedString("movie_watch__title", comment: SC.empty)
        }
        
        static var randomMovieButtonTitle: String {
            return NSLocalizedString("movie_random_title", comment: SC.empty)
        }
        
        static var favoritesLabel: String {
            return NSLocalizedString("movie_favorites_label", comment: SC.empty)
        }
        
        static var allButtonTitle: String {
            return NSLocalizedString("movie_all_title", comment: SC.empty)
        }
        
        static var allMoviesLabel: String {
            return NSLocalizedString("all_movies_label", comment: SC.empty)
        }
    }
}
