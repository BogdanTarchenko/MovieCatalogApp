//
//  SignInViewModel.swift
//  MovieCatalogApp
//
//  Created by Богдан Тарченко on 12.10.2024.
//

import Foundation
import KeychainAccess

class SignInViewModel {
    
    private let router: AppRouter
    
    private let signInUseCase: SignInUseCase
    
    var isSignInButtonActive: ((Bool) -> Void)?
    
    var credentials = LoginCredentials()
    
    init(router: AppRouter) {
        self.router = router
        self.signInUseCase = SignInUseCaseImpl.create()
    }
    
    func updateUsername(_ username: String) {
        self.credentials.username = username
        validateFields()
    }
    
    func updatePassword(_ password: String) {
        self.credentials.password = password
        validateFields()
    }
    
    func signInButtonTapped() {
        let requestBody = LoginCredentialsRequestModel(username: credentials.username,
                                                       password: credentials.password)
        
        signInUseCase.execute(request: requestBody) { result in
            switch result {
            case .success:
                print("vse chetko")
                self.router.navigateToFeed()
            case .failure(let error):
                print("error: \(error)")
                // TODO: - сделать алерт неправильное имя пользователя и/или пароль
            }
        }
    }
    
    private func validateFields() {
        let isValid = (self.credentials.username.isEmpty == false && self.credentials.password.isEmpty == false)
        isSignInButtonActive?(isValid)
    }
}
