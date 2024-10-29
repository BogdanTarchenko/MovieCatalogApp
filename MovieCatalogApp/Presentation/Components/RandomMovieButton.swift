//
//  RandomMovieButton.swift
//  MovieCatalogApp
//
//  Created by Богдан Тарченко on 28.10.2024.
//

import UIKit

final class RandomMovieButton: UIButton {
    private let button = CustomButton(style: .gradient)
    private let diceImage = UIImageView(image: UIImage(named: "dice"))
    
    init(title: String) {
        super.init(frame: .zero)
        setupButton()
        setupDiceImage()
        setupTitleLabel(title: title)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupButton() {
        addSubview(button)
        
        button.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.height.equalTo(96)
        }
    }
    
    private func setupDiceImage() {
        diceImage.contentMode = .scaleAspectFill
        diceImage.clipsToBounds = true
        
        button.addSubview(diceImage)
        
        diceImage.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(16)
        }
    }
    
    private func setupTitleLabel(title: String) {
        setTitle(title, for: .normal)
        self.titleLabel?.textAlignment = .right
        self.titleLabel?.font = UIFont(name: "Manrope-Bold", size: 20)
        self.titleLabel?.textColor = .textDefault
        
        titleLabel?.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview().inset(16)
        }
    }
}
