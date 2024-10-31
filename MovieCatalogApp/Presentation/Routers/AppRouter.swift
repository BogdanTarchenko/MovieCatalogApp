//
//  AppRouter.swift
//  MovieCatalogApp
//
//  Created by Богдан Тарченко on 11.10.2024.
//

import UIKit
import KeychainAccess
import SwiftUI

protocol AppRouterDelegate: AnyObject {
    func navigateToWelcome()
    func navigateToSignIn()
    func navigateToSignUp()
    func navigateToMain()
    func navigateToMovieDetails(movieID: String)
}

final class AppRouter: AppRouterDelegate {
    
    
    private var window: UIWindow?
    
    init(window: UIWindow?) {
        self.window = window
    }
    
    func start() {
        let keychain = Keychain()
        let authTokenExists = (try? keychain.get("authToken2")) != nil
        
        let initialViewController: UIViewController = authTokenExists ? createMainTabBarController() : createWelcomeViewController()
        
        window?.rootViewController = initialViewController
        window?.makeKeyAndVisible()
    }
}

// MARK: - Navigation Methods
extension AppRouter {
    
    func navigateToWelcome() {
        DispatchQueue.main.async {
            let welcomeViewController = self.createWelcomeViewController()
            self.transition(to: welcomeViewController)
        }
    }
    
    func navigateToSignIn() {
        let signInViewController = createSignInViewController()
        navigateToViewController(signInViewController, title: NSLocalizedString("sign_in_title", comment: ""))
    }
    
    func navigateToSignUp() {
        let signUpViewController = createSignUpViewController()
        navigateToViewController(signUpViewController, title: NSLocalizedString("sign_up_title", comment: ""))
    }
    
    func navigateToMain() {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            let mainTabBarController = self.createMainTabBarController()
            self.transition(to: mainTabBarController)
        }
    }
    
    func navigateToMovieDetails(movieID: String) {
        let movieDetailsView = createMovieDetailsView(movieID: movieID)
        let hostingController = UIHostingController(rootView: movieDetailsView)
        let navigationController = UINavigationController(rootViewController: hostingController)
        setupNavigationBar(for: hostingController, title: SC.empty)
        transition(to: navigationController)
    }
}

// MARK: - View Controller Creation
extension AppRouter {
    
    private func createMainTabBarController() -> MainTabBarController {
        let mainTabBarController = MainTabBarController()
        mainTabBarController.appRouterDelegate = self
        return mainTabBarController
    }
    
    private func createWelcomeViewController() -> UINavigationController {
        let welcomeViewModel = WelcomeViewModel()
        welcomeViewModel.appRouterDelegate = self
        let welcomeViewController = WelcomeViewController(viewModel: welcomeViewModel)
        return UINavigationController(rootViewController: welcomeViewController)
    }
    
    private func createSignInViewController() -> SignInViewController {
        let signInViewModel = SignInViewModel()
        signInViewModel.appRouterDelegate = self
        return SignInViewController(viewModel: signInViewModel)
    }
    
    private func createSignUpViewController() -> SignUpViewController {
        let signUpViewModel = SignUpViewModel()
        signUpViewModel.appRouterDelegate = self
        return SignUpViewController(viewModel: signUpViewModel)
    }
    
    private func createMovieDetailsView(movieID: String) -> MovieDetailsView {
        let movieDetailsViewModel = MovieDetailsViewModel(movieID: movieID)
        return MovieDetailsView(viewModel: movieDetailsViewModel)
    }
}

// MARK: - Navigation Bar Setup
extension AppRouter {
    
    private func navigateToViewController(_ viewController: UIViewController, title: String) {
        guard let navigationController = window?.rootViewController as? UINavigationController else { return }
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
        guard let navigationController = window?.rootViewController as? UINavigationController else { return }
        navigationController.popViewController(animated: true)
    }
    
    private func transition(to viewController: UIViewController) {
        guard let window = self.window else { return }
        UIView.transition(with: window, duration: 0.5, options: .transitionCrossDissolve) {
            window.rootViewController = viewController
            window.makeKeyAndVisible()
        }
    }
}
