//
//  LoadingViewController.swift
//  MovieCatalogApp
//
//  Created by Богдан Тарченко on 23.10.2024.
//

import UIKit
import Lottie

class LoadingViewController: UIViewController {
    private var animationView: LottieAnimationView!

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .background
        setupAnimationView()
    }
    
    func setupAnimationView() {
        animationView = LottieAnimationView(asset: "loading")
        animationView.frame = view.frame
        animationView.contentMode = .scaleAspectFit
        animationView.loopMode = .loop
        animationView.animationSpeed = 2.0
        view.addSubview(animationView)
        animationView.play()
        
        animationView.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }
}
