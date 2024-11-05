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
    
    var isUsernameValid: Bool = true {
        didSet {
            validateFields()
        }
    }
    var isPasswordValid: Bool = true {
        didSet {
            validateFields()
        }
    }

    init() {
        self.signInUseCase = SignInUseCaseImpl.create()
    }
    
    // MARK: - Public Methods
    func updateUsername(_ username: String) {
        self.credentials.username = username
        isUsernameValid = isValidLatinCharacters(username) && !username.isEmpty
        validateFields()
    }

    func updatePassword(_ password: String) {
        self.credentials.password = password
        isPasswordValid = isValidLatinCharacters(password) && !password.isEmpty
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
    private func isValidLatinCharacters(_ input: String) -> Bool {
        let regularExpression = "^[A-Za-z0-9#?!@$%^&*-]+$"
        let predicate = NSPredicate(format: "SELF MATCHES %@", regularExpression)
        return predicate.evaluate(with: input)
    }
    
    private func validateFields() {
        let isValid = isUsernameValid && isPasswordValid
        isSignInButtonActive?(isValid)
    }
}
