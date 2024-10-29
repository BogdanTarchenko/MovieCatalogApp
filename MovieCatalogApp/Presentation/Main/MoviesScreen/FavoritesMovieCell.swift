//
//  FavoritesMovieCell.swift
//  MovieCatalogApp
//
//  Created by Богдан Тарченко on 28.10.2024.
//

import UIKit
import Kingfisher

class FavoritesMovieCell: CarouselCell {
    
    private let imageView = UIImageView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        mainView = UIView(frame: contentView.bounds)
        contentView.addSubview(mainView)
        mainView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 8
        imageView.clipsToBounds = true
        
        mainView.addSubview(imageView)
        
        imageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    func configure(with movie: FavoritesMovieData) {
        let posterURL = movie.posterURL
        imageView.kf.setImage(with: URL(string: posterURL))
    }
}
