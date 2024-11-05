//
//  SignUpViewModel.swift
//  MovieCatalogApp
//
//  Created by Богдан Тарченко on 12.10.2024.
//

import Foundation
import KeychainAccess

final class SignUpViewModel {
    
    weak var delegate: AppRouterDelegate?
    
    private let signUpUseCase: SignUpUseCase
    
    var isSignUpButtonActive: ((Bool) -> Void)?
    var isLoading: ((Bool) -> Void)?
    
    var credentials = RegistrationCredentials()
    
    var isUsernameValid: Bool = false {
        didSet {
            validateFields()
        }
    }
    var isEmailValid: Bool = false {
        didSet {
            validateFields()
        }
    }
    var isNameValid: Bool = false {
        didSet {
            validateFields()
        }
    }
    var isPasswordValid: Bool = false {
        didSet {
            validateFields()
        }
    }
    var isRepeatedPasswordValid: Bool = false {
        didSet {
            validateFields()
        }
    }

    init() {
        self.signUpUseCase = SignUpUseCaseImpl.create()
    }
    
    // MARK: - Public Methods
    func updateUsername(_ username: String) {
        self.credentials.username = username
        isUsernameValid = isValidLatinCharacters(username) && !username.isEmpty
        validateFields()
    }
    
    func updateEmail(_ email: String) {
        self.credentials.email = email
        isEmailValid = !email.isEmpty && email.isValidEmail
        validateFields()
    }
    
    func updateName(_ name: String) {
        self.credentials.name = name
        isNameValid = !name.isEmpty
        validateFields()
    }
    
    func updatePassword(_ password: String) {
        self.credentials.password = password
        isPasswordValid = isValidLatinCharacters(password) && password.count >= 6
        validateFields()
    }

    
    func updateRepeatedPassword(_ repeatedPassword: String) {
        self.credentials.repeatedPassword = repeatedPassword
        isRepeatedPasswordValid = (repeatedPassword == credentials.password)
        validateFields()
    }
    
    func updateDateOfBirth(_ dateOfBirth: Date?) {
        self.credentials.dateOfBirth = dateOfBirth
        validateFields()
    }
    
    func updateGender(_ gender: Gender) {
        self.credentials.gender = gender
        validateFields()
    }
    
    func signUpButtonTapped() async {
        let requestBody = UserRegisterRequestModel(
            userName: credentials.username,
            name: credentials.name,
            password: credentials.password,
            email: credentials.email,
            birthDate: credentials.dateOfBirth?.ISO8601Format() ?? SC.empty,
            gender: credentials.gender.rawValue
        )
        
        isLoading?(true)
        
        defer {
            isLoading?(false)
        }
        
        Task {
            do {
                try await signUpUseCase.execute(request: requestBody)
                self.delegate?.navigateToMain()
            } catch {
                print(error)
            }
        }
    }
    
    // MARK: - Private Methods
    private func isValidLatinCharacters(_ input: String) -> Bool {
        let regularExpression = "^[A-Za-z0-9#?!@$%^&*-]+$"
        let predicate = NSPredicate(format: "SELF MATCHES %@", regularExpression)
        return predicate.evaluate(with: input)
    }

    
    private func validateFields() {
        let isUsernameValid = self.isUsernameValid
        let isEmailValid = !credentials.email.isEmpty
        let isNameValid = self.isNameValid
        let isPasswordValid = self.isPasswordValid
        let isRepeatedPasswordValid = self.isRepeatedPasswordValid
        let isDateOfBirthValid = credentials.dateOfBirth != nil
        
        let isValid = isUsernameValid && isEmailValid && isNameValid && isPasswordValid && isRepeatedPasswordValid && isDateOfBirthValid
        isSignUpButtonActive?(isValid)
    }
}
