//
//  ProfileTextField.swift
//  MovieCatalogApp
//
//  Created by Богдан Тарченко on 26.10.2024.
//

import UIKit
import SnapKit

class ProfileTextField: CustomTextField {
    
    private var titleLabel = UILabel()
    
    init(title: String) {
        super.init(style: .plain)
        
        titleLabel.text = title
        titleLabel.font = UIFont(name: "Manrope-Regular", size: 14)
        titleLabel.textColor = .textInformation
        
        addSubview(titleLabel)
        
        titleLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            make.bottom.equalTo(self.snp.top).offset(-4)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
