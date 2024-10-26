//
//  ProfileTextField.swift
//  MovieCatalogApp
//
//  Created by Богдан Тарченко on 26.10.2024.
//

import UIKit
import SnapKit

class ProfileTextField: UIView {
    
    enum ProfileTextFieldStyle {
        case information
        case date
    }
    
    private var titleLabel = UILabel()
    var textField: CustomTextField
    
    init(title: String, style: ProfileTextFieldStyle) {
        switch style {
        case .date:
            self.textField = CustomTextField(style: .date(.dateOfBirth))
        case .information:
            self.textField = CustomTextField(style: .plain)
        }
        
        super.init(frame: .zero)
        
        setupTextField()
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
    
    private func setupTextField() {
        addSubview(textField)
    }
    
    private func setupConstraints() {
        titleLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            make.bottom.equalTo(textField.snp.top).offset(-4)
        }
        
        textField.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalToSuperview()
            make.height.equalTo(48)
        }
        
        self.snp.makeConstraints { make in
            make.height.equalTo(72)
        }
    }
}
