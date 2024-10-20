//
//  SignUpViewModel.swift
//  MovieCatalogApp
//
//  Created by Богдан Тарченко on 12.10.2024.
//

import Foundation
import KeychainAccess

class SignUpViewModel {
    
    private let router: AppRouter
    
    private let signUpUseCase: SignUpUseCase
    
    var isSignUpButtonActive: ((Bool) -> Void)?
    
    var credentials = RegistrationCredentials()
    
    init(router: AppRouter) {
        self.router = router
        self.signUpUseCase = SignUpUseCaseImpl.create()
    }
    
    func updateUsername(_ username: String) {
        self.credentials.username = username
        validateFields()
    }
    
    func updateEmail(_ email: String) {
        self.credentials.email = email
        validateFields()
    }
    
    func updateName(_ name: String) {
        self.credentials.name = name
        validateFields()
    }
    
    func updatePassword(_ password: String) {
        self.credentials.password = password
        validateFields()
    }
    
    func updateRepeatedPassword(_ repeatedpassword: String) {
        self.credentials.repeatedPassword = repeatedpassword
        validateFields()
    }
    
    func updateDateOfBirth(_ dateOfBirth: Date?) {
        self.credentials.dateOfBirth = dateOfBirth
        validateFields()
    }
    
    func updateGender(_ gender: Gender) {
        self.credentials.gender = gender
        validateFields()
        print(gender.rawValue)
    }
    
    
    func signUpButtonTapped() {
        let requestBody = UserRegisterRequestModel(userName: credentials.username,
                                                   name: credentials.name,
                                                   password: credentials.password,
                                                   email: credentials.email,
                                                   birthDate: credentials.dateOfBirth?.ISO8601Format() ?? SC.empty,
                                                   gender: credentials.gender.rawValue)
        
        signUpUseCase.execute(request: requestBody) { result in
            switch result {
            case .success:
                print("vse chetko")
            case .failure(let error):
                print("error: \(error)")
                // TODO: - добавить обработку ошибки
            }
        }
    }
    
    private func validateFields() {
        let isUsernameValid = !(credentials.username.isEmpty)
        let isEmailValid = !(credentials.email.isEmpty)
        let isNameValid = !(credentials.name.isEmpty)
        let isPasswordValid = !(credentials.password.isEmpty)
        let isRepeatedPasswordValid = !(credentials.repeatedPassword.isEmpty) && (credentials.repeatedPassword == credentials.password)
        let isDateOfBirthValid = credentials.dateOfBirth != nil
        
        let isValid = isUsernameValid && isEmailValid && isNameValid && isPasswordValid && isRepeatedPasswordValid && isDateOfBirthValid
        isSignUpButtonActive?(isValid)
    }
}
