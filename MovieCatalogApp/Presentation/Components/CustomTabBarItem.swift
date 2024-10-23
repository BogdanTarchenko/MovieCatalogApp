//
//  CustomTabBarItem.swift
//  MovieCatalogApp
//
//  Created by Богдан Тарченко on 20.10.2024.
//

import UIKit
import SnapKit

class CustomTabBarItem: UIView {
    let button: UIButton
    let titleLabel: UILabel

    init(icon: String, title: String, action: UIAction, color: UIColor = .grayFaded) {
        button = UIButton(primaryAction: action)
        titleLabel = UILabel()

        super.init(frame: .zero)

        setupButton(icon: icon, color: color)
        setupTitleLabel(title: title)

        let stackView = UIStackView(arrangedSubviews: [button, titleLabel])
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.spacing = 4

        addSubview(stackView)
        
        stackView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupButton(icon: String, color: UIColor) {
        button.setImage(UIImage(named: icon), for: .normal)
        button.tintColor = color
    }

    private func setupTitleLabel(title: String) {
        titleLabel.text = title
        titleLabel.font = UIFont(name: "Manrope-Medium", size: 12)
        titleLabel.textColor = .grayFaded
        titleLabel.textAlignment = .center
    }
}
