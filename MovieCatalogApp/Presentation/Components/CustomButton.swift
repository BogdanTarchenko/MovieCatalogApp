//
//  CustomButton.swift
//  MovieCatalogApp
//
//  Created by Богдан Тарченко on 11.10.2024.
//

import UIKit

class CustomButton: UIButton {
    
    enum ButtonStyle {
        case gradient
        case plain
        case inactive
    }
    
    private var buttonStyle: ButtonStyle
    
    init(style: ButtonStyle) {
        self.buttonStyle = style
        super.init(frame: .zero)
        setupButton()
        configureStyle()
    }
    
    required init?(coder: NSCoder) {
        self.buttonStyle = .plain
        super.init(coder: coder)
        setupButton()
        configureStyle()
    }
    
    private func setupButton() {
        layer.cornerRadius = 8
        titleLabel?.textAlignment = .center
        titleLabel?.font = UIFont(name: "Manrope-Bold", size: 14)
        
        snp.makeConstraints { make in
            make.height.equalTo(48)
        }
    }
    
    private func configureStyle() {
        layer.sublayers?.forEach { layer in
            if layer is CAGradientLayer {
                layer.removeFromSuperlayer()
            }
        }
        
        switch buttonStyle {
        case .gradient:
            applyGradientBackground()
            setTitleColor(.textDefault, for: .normal)
            isUserInteractionEnabled = true
        case .plain:
            backgroundColor = .darkFaded
            setTitleColor(.textDefault, for: .normal)
            isUserInteractionEnabled = true
        case .inactive:
            backgroundColor = .darkFaded
            setTitleColor(.grayFaded, for: .normal)
            isUserInteractionEnabled = false
        }
    }
    
    private func applyGradientBackground() {
        let gradientColors = [
            UIColor(red: 223/255, green: 40/255, blue: 0/255, alpha: 1).cgColor,
            UIColor(red: 255/255, green: 102/255, blue: 51/255, alpha: 1).cgColor
        ]
        
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = gradientColors
        gradientLayer.startPoint = CGPoint(x: 0, y: 0.5)
        gradientLayer.endPoint = CGPoint(x: 1, y: 0.5)
        gradientLayer.frame = bounds
        gradientLayer.cornerRadius = layer.cornerRadius
        
        layer.insertSublayer(gradientLayer, at: 0)
    }
    
    override var isHighlighted: Bool {
        didSet {
            updateButtonAppearance(for: isHighlighted)
        }
    }
    
    private func updateButtonAppearance(for highlighted: Bool) {
        let targetAlpha: CGFloat = highlighted ? 0.7 : 1.0
        UIView.animate(withDuration: 0.1) {
            self.alpha = targetAlpha
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        if let gradientLayer = layer.sublayers?.first as? CAGradientLayer {
            gradientLayer.frame = bounds
        }
    }
    
    func toggleStyle(_ style: ButtonStyle) {
        buttonStyle = style
        configureStyle()
    }
}
