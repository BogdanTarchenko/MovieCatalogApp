//
//  SignInViewModel.swift
//  MovieCatalogApp
//
//  Created by Богдан Тарченко on 12.10.2024.
//

import Foundation
import KeychainAccess

final class SignInViewModel {
    
    weak var appRouterDelegate: AppRouterDelegate?
    
    private let signInUseCase: SignInUseCase
    
    var isSignInButtonActive: ((Bool) -> Void)?
    var isLoading: ((Bool) -> Void)?
    
    var credentials = LoginCredentials()
    
    init() {
        self.signInUseCase = SignInUseCaseImpl.create()
    }
    
    // MARK: - Public Methods
    func updateUsername(_ username: String) {
        self.credentials.username = username
        validateFields()
    }
    
    func updatePassword(_ password: String) {
        self.credentials.password = password
        validateFields()
    }
    
    func signInButtonTapped() async {
        let requestBody = LoginCredentialsRequestModel(
            username: credentials.username,
            password: credentials.password
        )
        
        isLoading?(true)
        
        defer {
            isLoading?(false)
        }
        do {
            try await signInUseCase.execute(request: requestBody)
            self.appRouterDelegate?.navigateToMain()
        } catch {
            print(error)
        }
    }
    
    
    // MARK: - Private Methods
    private func validateFields() {
        let isValid = !self.credentials.username.isEmpty && !self.credentials.password.isEmpty
        isSignInButtonActive?(isValid)
    }
}
