//
//  MoviePosterCell.swift
//  MovieCatalogApp
//
//  Created by Богдан Тарченко on 29.10.2024.
//

import UIKit
import SnapKit

final class MoviePosterCell: UICollectionViewCell {
    
    private let posterImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 8
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private let ratingLabel: PaddingLabel = {
        let label = PaddingLabel()
        label.font = UIFont(name: "Manrope-Medium", size: 12)
        label.textColor = .textDefault
        label.textAlignment = .center
        label.layer.cornerRadius = 4
        label.clipsToBounds = true
        label.textInsets = UIEdgeInsets(top: 4, left: 8, bottom: 4, right: 8)
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupViews()
    }
    
    private func setupViews() {
        contentView.addSubview(posterImageView)
        posterImageView.addSubview(ratingLabel)
        
        posterImageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        ratingLabel.snp.makeConstraints { make in
            make.top.left.equalToSuperview().inset(8)
        }
    }
    
    func configure(with poster: UIImage, title: String, rating: Double) {
        posterImageView.image = poster
        ratingLabel.text = "\(rating)"

        let color = colorForRating(rating)
        ratingLabel.backgroundColor = color
    }

    private func colorForRating(_ rating: Double) -> UIColor {
        switch rating {
        case 0.0..<4.0:
            let normalizedValue = rating / 4.0
            return blend(color1: .darkRed, color2: .red, ratio: CGFloat(normalizedValue))
        case 4.0..<7.0:
            let normalizedValue = (rating - 4.0) / 3.0
            return blend(color1: .red, color2: .orange, ratio: CGFloat(normalizedValue))
        case 7.0...10.0:
            let normalizedValue = (rating - 7.0) / 3.0
            return blend(color1: .orange, color2: .green, ratio: CGFloat(normalizedValue))
        default:
            return .green
        }
    }

    private func blend(color1: UIColor, color2: UIColor, ratio: CGFloat) -> UIColor {
        let ratio = max(0, min(1, ratio))
        var (r1, g1, b1, a1): (CGFloat, CGFloat, CGFloat, CGFloat) = (0, 0, 0, 0)
        var (r2, g2, b2, a2): (CGFloat, CGFloat, CGFloat, CGFloat) = (0, 0, 0, 0)

        color1.getRed(&r1, green: &g1, blue: &b1, alpha: &a1)
        color2.getRed(&r2, green: &g2, blue: &b2, alpha: &a2)

        return UIColor(
            red: r1 + (r2 - r1) * ratio,
            green: g1 + (g2 - g1) * ratio,
            blue: b1 + (b2 - b1) * ratio,
            alpha: a1 + (a2 - a1) * ratio
        )
    }
}
