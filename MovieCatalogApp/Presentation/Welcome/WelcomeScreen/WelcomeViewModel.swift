//
//  WelcomeViewModel.swift
//  MovieCatalogApp
//
//  Created by Богдан Тарченко on 11.10.2024.
//

final class WelcomeViewModel {
    
    private let router: AppRouter
    
    init(router: AppRouter) {
        self.router = router
    }
    
    // MARK: - Public Methods
    func signInButtonTapped() {
        router.navigateToSignIn()
    }
    
    func signUpButtonTapped() {
        router.navigateToSignUp()
    }
}
