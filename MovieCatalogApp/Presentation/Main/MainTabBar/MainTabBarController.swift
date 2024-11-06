//
//  MainTabBarController.swift
//  MovieCatalogApp
//
//  Created by Богдан Тарченко on 19.10.2024.
//

import UIKit
import SnapKit
import SwiftUI

enum TabBarItem: CaseIterable {
    case feed, movies, favourites, profile
    
    var activeIcon: String {
        switch self {
        case .feed:
            return "feed_gradient"
        case .movies:
            return "movies_gradient"
        case .favourites:
            return "favorites_gradient"
        case .profile:
            return "profile_gradient"
        }
    }
    
    var inactiveIcon: String {
        switch self {
        case .feed:
            return "feed"
        case .movies:
            return "movies"
        case .favourites:
            return "favourites"
        case .profile:
            return "profile"
        }
    }
    
    var title: String {
        switch self {
        case .feed:
            return LocalizedString.TabBar.feed
        case .movies:
            return LocalizedString.TabBar.movies
        case .favourites:
            return LocalizedString.TabBar.favorites
        case .profile:
            return LocalizedString.TabBar.profile
        }
    }
}

final class MainTabBarController: UITabBarController {
    
    weak var appRouterDelegate: AppRouterDelegate?
    
    private lazy var feedViewController: FeedViewController = {
        let viewModel = FeedViewModel()
        return FeedViewController(viewModel: viewModel)
    }()
    
    private lazy var moviesViewController: MoviesViewController = {
        let viewModel = MoviesViewModel()
        viewModel.delegate = self
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
    
    private lazy var feedButton = getButton(for: .feed, action: action(for: 0))
    private lazy var moviesButton = getButton(for: .movies, action: action(for: 1))
    private lazy var favouritesButton = getButton(for: .favourites, action: action(for: 2))
    private lazy var profileButton = getButton(for: .profile, action: action(for: 3))
    
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
    
    private func getButton(for item: TabBarItem, action: UIAction) -> CustomTabBarItem {
        return CustomTabBarItem(icon: item.inactiveIcon, title: item.title, action: action)
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
            let items = TabBarItem.allCases
            let buttons = [self.feedButton, self.moviesButton, self.favouritesButton, self.profileButton]
            
            buttons.enumerated().forEach { index, button in
                if index == selectedIndex {
                    button.button.setImage(UIImage(named: items[index].activeIcon)?.withRenderingMode(.alwaysOriginal), for: .normal)
                    self.applyGradientTo(button: button.titleLabel)
                } else {
                    button.button.setImage(UIImage(named: items[index].inactiveIcon), for: .normal)
                    button.titleLabel.textColor = .grayFaded
                }
            }
        }
    }
    
    
    private func applyGradientTo(button label: UILabel?) {
        guard let label = label else { return }
        
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = label.bounds
        gradientLayer.colors = [UIColor(red: 223/255, green: 40/255, blue: 0/255, alpha: 1).cgColor,
                                UIColor(red: 255/255, green: 102/255, blue: 51/255, alpha: 1).cgColor]
        gradientLayer.startPoint = CGPoint(x: 0, y: 0.5)
        gradientLayer.endPoint = CGPoint(x: 1, y: 0.5)
        
        UIGraphicsBeginImageContextWithOptions(label.bounds.size, false, 0)
        gradientLayer.render(in: UIGraphicsGetCurrentContext()!)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        label.textColor = UIColor(patternImage: image!)
    }
}

extension MainTabBarController: ProfileViewModelDelegate, FavoritesViewModelRouterDelegate, MoviesViewModelRouterDelegate {
    func navigateToWelcome() {
        appRouterDelegate?.navigateToWelcome()
    }
    
    func navigateToFriends() {
        appRouterDelegate?.navigateToFriends()
    }
    
    func navigateToMain() {
        selectedIndex = 0
        setColor(selectedIndex: 0)
    }
    
    func navigateToFavorites() {
        selectedIndex = 2
        setColor(selectedIndex: 2)
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
