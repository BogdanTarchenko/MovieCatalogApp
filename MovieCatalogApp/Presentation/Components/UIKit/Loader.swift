//
//  Loader.swift
//  MovieCatalogApp
//
//  Created by Богдан Тарченко on 25.10.2024.
//

import UIKit
import Lottie
import SnapKit

protocol Loader {
    func startAnimating()
    func finishAnimating()
}

final class LoaderView: UIView, Loader {
    private let animationView: LottieAnimationView = {
        let animation = LottieAnimationView(name: "loading")
        animation.contentMode = .scaleAspectFill
        animation.loopMode = .loop
        return animation
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        addSubview(animationView)
        
        animationView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }

    func startAnimating() {
        animationView.play()
    }

    func finishAnimating() {
        animationView.stop()
    }
}
