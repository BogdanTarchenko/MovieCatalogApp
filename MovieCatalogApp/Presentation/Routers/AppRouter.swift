//
//  AppRouter.swift
//  MovieCatalogApp
//
//  Created by Богдан Тарченко on 11.10.2024.
//

import UIKit
import KeychainAccess

class AppRouter {
    
    private var window: UIWindow?
    
    init(window: UIWindow?) {
        self.window = window
    }
    
    func start() {
        let keychain = Keychain()
        
        if let authToken = try? keychain.get("authToken1") {
            let mainTabBarController = MainTabBarController()
            window?.rootViewController = mainTabBarController
        } else {
            let welcomeViewModel = WelcomeViewModel(router: self)
            let welcomeViewController = WelcomeViewController(viewModel: welcomeViewModel)
            let navigationController = UINavigationController(rootViewController: welcomeViewController)
            window?.rootViewController = navigationController
        }
        
        window?.makeKeyAndVisible()
    }
}

// MARK: - Navigation Methods
extension AppRouter {
    func navigateToSignIn() {
        let signInViewModel = SignInViewModel(router: self)
        let signInViewController = SignInViewController(viewModel: signInViewModel)
        navigateToViewController(signInViewController, title: NSLocalizedString("sign_in_title", comment: ""))
    }
    
    func navigateToSignUp() {
        let signUpViewModel = SignUpViewModel(router: self)
        let signUpViewController = SignUpViewController(viewModel: signUpViewModel)
        navigateToViewController(signUpViewController, title: NSLocalizedString("sign_up_title", comment: ""))
    }
    
    func navigateToFeed() {
        DispatchQueue.main.async { [weak self] in
            let mainTabBarController = MainTabBarController()
            self?.window?.rootViewController = mainTabBarController
            self?.window?.makeKeyAndVisible()
        }
    }
}

// MARK: - Navigation Bar Setup
extension AppRouter {
    func navigateToViewController(_ viewController: UIViewController, title: String) {
        guard let navigationController = window?.rootViewController as? UINavigationController else {
            return
        }
        
        setupNavigationBar(for: viewController, title: title)
        navigationController.pushViewController(viewController, animated: true)
    }
    
    private func setupNavigationBar(for viewController: UIViewController, title: String) {
        viewController.navigationItem.hidesBackButton = true
        
        let titleLabel = UILabel()
        titleLabel.text = title
        titleLabel.font = UIFont(name: "Manrope-Bold", size: 24)
        titleLabel.textColor = .white
        
        let backButton = UIButton(type: .custom)
        backButton.setImage(UIImage(named: "back_button"), for: .normal)
        backButton.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
        
        let backBarButtonItem = UIBarButtonItem(customView: backButton)
        
        viewController.navigationItem.leftBarButtonItems = [
            backBarButtonItem,
            UIBarButtonItem(customView: titleLabel)
        ]
    }
    
    @objc private func backButtonTapped() {
        if let navigationController = window?.rootViewController as? UINavigationController {
            navigationController.popViewController(animated: true)
        }
    }
}
