//
//  SplitButton.swift
//  MovieCatalogApp
//
//  Created by Богдан Тарченко on 12.10.2024.
//

import UIKit

class SplitButton: UIView {
    
    private let leftButton: CustomButton
    private let rightButton: CustomButton

    init(leftTitle: String, rightTitle: String) {
        self.leftButton = CustomButton(style: .plain)
        self.rightButton = CustomButton(style: .gradient)
        
        super.init(frame: .zero)
        
        setupView()
        setupButtons()
        configureButtons(with: leftTitle, rightTitle: rightTitle)
        layoutButtons()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupView() {
        layer.cornerRadius = 8
        clipsToBounds = true
    }

    private func setupButtons() {
        leftButton.layer.cornerRadius = 0
        rightButton.layer.cornerRadius = 0
        leftButton.addTarget(self, action: #selector(leftButtonTapped), for: .touchUpInside)
        rightButton.addTarget(self, action: #selector(rightButtonTapped), for: .touchUpInside)

        addSubview(leftButton)
        addSubview(rightButton)
    }

    private func configureButtons(with leftTitle: String, rightTitle: String) {
        leftButton.setTitle(leftTitle, for: .normal)
        rightButton.setTitle(rightTitle, for: .normal)
        
        leftButton.toggleStyle(.plain)
        rightButton.toggleStyle(.gradient)
    }

    private func layoutButtons() {
        leftButton.snp.makeConstraints { make in
            make.leading.top.bottom.equalToSuperview()
            make.trailing.equalTo(rightButton.snp.leading)
            make.width.equalTo(rightButton)
        }
        
        rightButton.snp.makeConstraints { make in
            make.trailing.top.bottom.equalToSuperview()
            make.width.equalTo(leftButton)
        }
    }

    @objc private func leftButtonTapped() {
        if rightButton.isUserInteractionEnabled {
            rightButton.toggleStyle(.plain)
            leftButton.toggleStyle(.gradient)
        }
    }

    @objc private func rightButtonTapped() {
        if leftButton.isUserInteractionEnabled {
            leftButton.toggleStyle(.plain)
            rightButton.toggleStyle(.gradient)
        }
    }
}
