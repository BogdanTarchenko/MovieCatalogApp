//
//  UIViewController+Extensions.swift
//  MovieCatalogApp
//
//  Created by Богдан Тарченко on 23.10.2024.
//

import UIKit

// MARK: - Loading
extension UIViewController {
    
    private var loadingViewController: LoadingViewController? {
        return children.compactMap { $0 as? LoadingViewController }.first
    }
    
    @MainActor
    func showLoadingScreen() {
        let loadingVC = LoadingViewController()
        loadingVC.modalPresentationStyle = .overFullScreen
        present(loadingVC, animated: false, completion: nil)
    }
    
    @MainActor
    func hideLoadingScreen() {
        dismiss(animated: false)
    }
}
