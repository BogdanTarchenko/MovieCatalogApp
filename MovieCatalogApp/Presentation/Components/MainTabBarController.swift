//
//  MainTabBarController.swift
//  MovieCatalogApp
//
//  Created by Богдан Тарченко on 19.10.2024.
//

import UIKit
import SnapKit
import SwiftUI

final class MainTabBarController: UITabBarController {
        
    weak var appRouterDelegate: AppRouterDelegate?
    
    private lazy var feedViewController: FeedViewController = {
        let viewModel = FeedViewModel()
        return FeedViewController(viewModel: viewModel)
    }()
    
    private lazy var moviesViewController: MoviesViewController = {
        let viewModel = MoviesViewModel()
        return MoviesViewController(viewModel: viewModel)
    }()
    
    private lazy var favoritesView: FavoritesView = {
        let viewModel = FavoritesViewModel()
        viewModel.delegate = self
        return FavoritesView(viewModel: viewModel)
    }()
    
    private lazy var profileViewController: ProfileViewController = {
        let viewModel = ProfileViewModel()
        viewModel.delegate = self
        return ProfileViewController(viewModel: viewModel)
    }()
    
    private lazy var feedButton = getButton(icon: "feed", title: LocalizedString.TabBar.feed, action: action(for: 0))
    private lazy var moviesButton = getButton(icon: "movies", title: LocalizedString.TabBar.movies, action: action(for: 1))
    private lazy var favouritesButton = getButton(icon: "favourites", title: LocalizedString.TabBar.favorites, action: action(for: 2))
    private lazy var profileButton = getButton(icon: "profile", title: LocalizedString.TabBar.profile, action: action(for: 3))
    
    private lazy var customBar: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .equalSpacing
        stackView.alignment = .center
        stackView.backgroundColor = .darkFaded
        stackView.frame = CGRect(x: 24, y: view.frame.height - 94, width: view.frame.width - 48, height: 64)
        stackView.layer.cornerRadius = 16
        
        stackView.addArrangedSubview(UIView())
        stackView.addArrangedSubview(feedButton)
        stackView.addArrangedSubview(moviesButton)
        stackView.addArrangedSubview(favouritesButton)
        stackView.addArrangedSubview(profileButton)
        stackView.addArrangedSubview(UIView())
        
        return stackView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(customBar)
        
        self.tabBar.backgroundImage = UIImage()
        
        let hostingController = UIHostingController(rootView: favoritesView)
        DispatchQueue.main.async { [weak self] in
            self?.setViewControllers([self?.feedViewController, self?.moviesViewController, hostingController, self?.profileViewController].compactMap { $0 }, animated: true)
            self?.setColor(selectedIndex: 0)
        }
    }
    
    private func getButton(icon: String, title: String, action: UIAction) -> CustomTabBarItem {
        return CustomTabBarItem(icon: icon, title: title, action: action)
    }
    
    private func action(for index: Int) -> UIAction {
        return UIAction { [weak self] _ in
            guard let self = self else { return }
            
            selectedIndex = index
            setColor(selectedIndex: index)
        }
    }
    
    private func setColor(selectedIndex: Int) {
        DispatchQueue.main.async {
            let buttons = [self.feedButton, self.moviesButton, self.favouritesButton, self.profileButton]
            
            buttons.enumerated().forEach { index, button in
                if index == selectedIndex {
                    button.button.tintColor = .accent
                    button.titleLabel.textColor = .accent
                } else {
                    button.button.tintColor = .grayFaded
                    button.titleLabel.textColor = .grayFaded
                }
            }
        }
    }
}

extension MainTabBarController: ProfileViewModelDelegate, FavoritesViewModelRouterDelegate {
    func navigateToWelcome() {
        appRouterDelegate?.navigateToWelcome()
    }
    
    func navigateToMain() {
        selectedIndex = 0
        setColor(selectedIndex: 0)
    }
    
    func navigateToMovieDetails(movieID: String) {
        let movieDetailsViewModel = MovieDetailsViewModel(movieID: movieID)
        movieDetailsViewModel.onDismiss = { [weak self] in
            self?.dismiss(animated: true)
        }
        
        let movieDetailsView = MovieDetailsView(viewModel: movieDetailsViewModel)
        let hostingController = UIHostingController(rootView: movieDetailsView)
        let navigationController = UINavigationController(rootViewController: hostingController)
        navigationController.modalPresentationStyle = .fullScreen
        
        self.present(navigationController, animated: true)
    }
}
