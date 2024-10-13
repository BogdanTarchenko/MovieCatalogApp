//
//  WelcomeViewModel.swift
//  MovieCatalogApp
//
//  Created by Богдан Тарченко on 11.10.2024.
//

protocol WelcomeViewModelProtocol: AnyObject {
    func signInButtonTapped()
    func signUpButtonTapped()
}

class WelcomeViewModel: WelcomeViewModelProtocol {
    private let router: AppRouter
    
    init(router: AppRouter) {
        self.router = router
    }
    
    func signInButtonTapped() {
        router.navigateToSignIn()
    }
    
    func signUpButtonTapped() {
        router.navigateToSignUp()
    }
}
