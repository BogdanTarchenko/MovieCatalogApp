//
//  SignInViewModel.swift
//  MovieCatalogApp
//
//  Created by Богдан Тарченко on 12.10.2024.
//

import Foundation

class SignInViewModel {
    private let router: AppRouter
    var isSignInButtonActive: ((Bool) -> Void)?
    
    var username: String?
    var password: String?
    
    init(router: AppRouter) {
        self.router = router
    }
    
    func updateUsername(_ username: String?) {
        self.username = username
        validateFields()
    }
    
    func updatePassword(_ password: String?) {
        self.password = password
        validateFields()
    }
    
    private func validateFields() {
        let isValid = (username?.isEmpty == false && password?.isEmpty == false)
        isSignInButtonActive?(isValid)
    }
}
