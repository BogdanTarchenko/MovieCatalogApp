//
//  SignUpViewModel.swift
//  MovieCatalogApp
//
//  Created by Богдан Тарченко on 12.10.2024.
//

import Foundation

class SignUpViewModel {
    private let router: AppRouter
    var isSignUpButtonActive: ((Bool) -> Void)?
    
    var username: String?
    var email: String?
    var name: String?
    var password: String?
    var repeatedPassword: String?
    var dateOfBirth: Date?
    
    init(router: AppRouter) {
        self.router = router
    }
    
    func updateUsername(_ username: String?) {
        self.username = username
        validateFields()
    }
    
    func updateEmail(_ email: String?) {
        self.email = email
        validateFields()
    }
    
    func updateName(_ name: String?) {
        self.name = name
        validateFields()
    }
    
    func updatePassword(_ password: String?) {
        self.password = password
        validateFields()
    }
    
    func updateRepeatedPassword(_ repeatedpassword: String?) {
        self.repeatedPassword = repeatedpassword
        validateFields()
    }
    
    func updateDateOfBirth(_ dateOfBirth: Date?) {
        self.dateOfBirth = dateOfBirth
        validateFields()
    }
    
    private func validateFields() {
        let isUsernameValid = !(username?.isEmpty ?? true)
        let isEmailValid = !(email?.isEmpty ?? true)
        let isNameValid = !(name?.isEmpty ?? true)
        let isPasswordValid = !(password?.isEmpty ?? true)
        let isRepeatedPasswordValid = !(repeatedPassword?.isEmpty ?? true) && (repeatedPassword == password)
        let isDateOfBirthValid = dateOfBirth != nil

        let isValid = isUsernameValid && isEmailValid && isNameValid && isPasswordValid && isRepeatedPasswordValid && isDateOfBirthValid
        isSignUpButtonActive?(isValid)
    }
}
