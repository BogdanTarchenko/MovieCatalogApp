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
    
    var likeButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "liked_movie"), for: .normal)
        return button
    }()
    
    var onTap: (() -> Void)?

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        setupGestureRecognizers()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupViews()
        setupGestureRecognizers()
    }
    
    private func setupViews() {
        contentView.addSubview(posterImageView)
        posterImageView.addSubview(ratingLabel)
        posterImageView.addSubview(likeButton)
        
        posterImageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        ratingLabel.snp.makeConstraints { make in
            make.top.leading.equalToSuperview().inset(8)
            make.height.equalTo(22)
        }
        
        likeButton.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(8)
            make.leading.equalTo(ratingLabel.snp.trailing).offset(4)
        }
    }
    
    private func setupGestureRecognizers() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        contentView.isUserInteractionEnabled = true
        contentView.addGestureRecognizer(tapGesture)
    }
    
    // MARK: - Actions
    @objc private func handleTap() {
        onTap?()
    }
    
    func configure(with movie: AllMovieData) {
        let posterURL = movie.posterURL
        posterImageView.kf.setImage(with: URL(string: posterURL))
        
        guard !movie.reviews.isEmpty else {
            ratingLabel.isHidden = true
            return
        }
        
        let totalRating = movie.reviews.reduce(0) { $0 + $1.rating }
        let averageRating = Double(totalRating) / Double(movie.reviews.count)

        ratingLabel.text = String(format: "%.1f", averageRating)
        ratingLabel.backgroundColor = colorForRating(averageRating)
    }

    private func colorForRating(_ rating: Double) -> UIColor {
        switch rating {
        case 0.0..<2.5:
            return blend(color1: .darkRed, color2: .red, ratio: CGFloat(rating / 4.0))
        case 2.5..<6.0:
            return blend(color1: .red, color2: .orange, ratio: CGFloat((rating - 2.5) / 3.0))
        case 6.0...10.0:
            return blend(color1: .orange, color2: .green, ratio: CGFloat((rating - 6.0) / 3.0))
        default:
            return .green
        }
    }

    private func blend(color1: UIColor, color2: UIColor, ratio: CGFloat) -> UIColor {
        let ratio = max(0, min(0.75, ratio))
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
