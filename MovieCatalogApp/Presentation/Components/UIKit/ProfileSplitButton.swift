//
//  ProfileSplitButton.swift
//  MovieCatalogApp
//
//  Created by Богдан Тарченко on 27.10.2024.
//

import UIKit
import SnapKit

final class ProfileGenderButton: UIView {
    
    private var titleLabel = UILabel()
    var genderButton = SplitButton(style: .genderPicker)
    
    init(title: String) {
        super.init(frame: .zero)
        
        setupGenderButton()
        setupTitleLabel(with: title)
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupTitleLabel(with title: String) {
        titleLabel.text = title
        titleLabel.font = UIFont(name: "Manrope-Regular", size: 14)
        titleLabel.textColor = .textInformation
        
        addSubview(titleLabel)
    }
    
    private func setupGenderButton() {
        addSubview(genderButton)
    }
    
    private func setupConstraints() {
        titleLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            make.bottom.equalTo(genderButton.snp.top).offset(-4)
        }
        
        genderButton.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalToSuperview()
            make.height.equalTo(48)
        }
        
        self.snp.makeConstraints { make in
            make.height.equalTo(72)
        }
    }
}
