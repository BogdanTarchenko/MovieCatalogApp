//
//  WelcomeViewModel.swift
//  MovieCatalogApp
//
//  Created by Богдан Тарченко on 11.10.2024.
//

final class WelcomeViewModel {
    
    weak var delegate: AppRouterDelegate?
    
    // MARK: - Public Methods
    func signInButtonTapped() {
        delegate?.navigateToSignIn()
    }
    
    func signUpButtonTapped() {
        delegate?.navigateToSignUp()
    }
}
