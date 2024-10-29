//
//  CarouselCell.swift
//  MovieCatalogApp
//
//  Created by Богдан Тарченко on 29.10.2024.
//

import UIKit

class CarouselCell: UICollectionViewCell {
    
    private let scaleMinimum: CGFloat = 0.9
    private let scaleDivisor: CGFloat = 10.0
    private let cornerRadius: CGFloat = 20.0
    let alphaMinimum: CGFloat = 0.85
    
    var mainView = UIView()
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        mainView.transform = .identity
        mainView.alpha = 1.0
    }
    
    func updateScaleAndAlpha(scale: CGFloat, alpha: CGFloat) {
        mainView.transform = CGAffineTransform(scaleX: scale, y: scale)
        mainView.alpha = alpha
        mainView.layer.cornerRadius = cornerRadius
    }
}
