//
//  MainTabBarController.swift
//  MovieCatalogApp
//
//  Created by Богдан Тарченко on 19.10.2024.
//

import UIKit

class MainTabBarController: UITabBarController, UITabBarControllerDelegate {
    
    private let tabBarBackgroundView = UIView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self
        
        let feedViewController = FeedViewController()
        feedViewController.tabBarItem = UITabBarItem(title: "Лента", image: UIImage(named: "feed"), tag: 0)
        
        let moviesViewController = MoviesViewController()
        moviesViewController.tabBarItem = UITabBarItem(title: "Фильмы", image: UIImage(named: "movies"), tag: 1)
        
        let favouritesViewController = FavouritesViewController()
        favouritesViewController.tabBarItem = UITabBarItem(title: "Избранное", image: UIImage(named: "favourites"), tag: 2)
        
        let profileViewController = ProfileViewController()
        profileViewController.tabBarItem = UITabBarItem(title: "Профиль", image: UIImage(named: "profile"), tag: 3)
        
        viewControllers = [feedViewController, moviesViewController, favouritesViewController, profileViewController]
        
        setupCustomTabBar()
    }
    
    func setupCustomTabBar() {
        tabBarBackgroundView.backgroundColor = .darkFaded
        tabBarBackgroundView.layer.cornerRadius = 16
        tabBarBackgroundView.layer.masksToBounds = true
        
        view.addSubview(tabBarBackgroundView)
        view.bringSubviewToFront(tabBar)
        
        tabBarBackgroundView.snp.makeConstraints { make in
            make.leading.trailing.equalTo(tabBar).inset(24)
            make.top.equalTo(tabBar)
            make.bottom.equalTo(view.safeAreaLayoutGuide)
        }
        
        let appearance = UITabBarAppearance()
        appearance.configureWithTransparentBackground()
        tabBar.standardAppearance = appearance
        tabBar.scrollEdgeAppearance = appearance
        
        tabBar.itemPositioning = .centered
        tabBar.itemSpacing = 0
    }
}
