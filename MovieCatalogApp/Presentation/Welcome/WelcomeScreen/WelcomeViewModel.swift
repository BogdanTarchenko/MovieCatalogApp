//
//  WelcomeViewModel.swift
//  MovieCatalogApp
//
//  Created by Богдан Тарченко on 11.10.2024.
//

final class WelcomeViewModel {
    
    weak var appRouterDelegate: AppRouterDelegate?
    
    // MARK: - Public Methods
    func signInButtonTapped() {
        appRouterDelegate?.navigateToSignIn()
    }
    
    func signUpButtonTapped() {
        appRouterDelegate?.navigateToSignUp()
    }
}
