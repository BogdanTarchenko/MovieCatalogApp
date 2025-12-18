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
    func navigateToFriends()
}

final class AppRouter: AppRouterDelegate {
    
    private var window: UIWindow?
    
    init(window: UIWindow?) {
        self.window = window
    }
    
    func start() {
        let keychain = Keychain()
        let authTokenExists = (try? keychain.get("authToken")) != nil
        
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
        navigateToViewController(signInViewController, title: LocalizedString.SignIn.title)
    }
    
    func navigateToSignUp() {
        let signUpViewController = createSignUpViewController()
        navigateToViewController(signUpViewController, title: LocalizedString.SignUp.title)
    }
    
    func navigateToMain() {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            let mainTabBarController = self.createMainTabBarController()
            self.transition(to: mainTabBarController)
        }
    }
    
    func navigateToFriends() {
        let friendsViewController = createFriendsViewController()
        let navigationController = UINavigationController(rootViewController: friendsViewController)
        navigationController.modalPresentationStyle = .fullScreen
        setupNavigationBar(for: friendsViewController, title: LocalizedString.Friends.friendsTitle, isPresent: true)
        guard let viewController = window?.rootViewController else { return }
        viewController.present(navigationController, animated: true)
    }
}

// MARK: - ViewController Creation
extension AppRouter {
    
    private func createMainTabBarController() -> MainTabBarController {
        let mainTabBarController = MainTabBarController()
        mainTabBarController.appRouterDelegate = self
        return mainTabBarController
    }
    
    private func createWelcomeViewController() -> UINavigationController {
        let welcomeViewModel = WelcomeViewModel()
        welcomeViewModel.delegate = self
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
    
    private func createFriendsViewController() -> FriendViewController {
        let friendsViewModel = FriendsViewModel()
        return FriendViewController(viewModel: friendsViewModel)
    }
}

// MARK: - Navigation Bar Setup
extension AppRouter {
    
    private func navigateToViewController(_ viewController: UIViewController, title: String) {
        guard let navigationController = window?.rootViewController as? UINavigationController else { return }
        setupNavigationBar(for: viewController, title: title)
        navigationController.pushViewController(viewController, animated: true)
    }
    
    private func setupNavigationBar(for viewController: UIViewController, title: String, isPresent: Bool = false) {
        
        viewController.navigationItem.hidesBackButton = true
        
        let titleLabel = UILabel()
        titleLabel.text = title
        titleLabel.font = UIFont(name: "Manrope-Bold", size: 24)
        titleLabel.textColor = .white
        
        let backButton = UIButton(type: .custom)
        backButton.setImage(UIImage(named: "back_button"), for: .normal)
        
        if isPresent {
            backButton.addTarget(self, action: #selector(backButtonTappedPresented), for: .touchUpInside)
        } else {
            backButton.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
        }
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
    
    @objc private func backButtonTappedPresented() {
        guard let viewController = window?.rootViewController else { return }
        viewController.dismiss(animated: true)
    }
    
    private func transition(to viewController: UIViewController) {
        guard let window = self.window else { return }
        UIView.transition(with: window, duration: 0.5, options: .transitionCrossDissolve) {
            window.rootViewController = viewController
            window.makeKeyAndVisible()
        }
    }
}
