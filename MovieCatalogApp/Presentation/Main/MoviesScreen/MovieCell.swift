//
//  MovieCell.swift
//  MovieCatalogApp
//
//  Created by Богдан Тарченко on 28.10.2024.
//

import UIKit

class MovieCell: UICollectionViewCell {

    private let imageView = UIImageView()
    private let vignetteView = UIView()
    private let progressBar = UIProgressView()
    private let titleLabel = UILabel()
    private let genreButtonsStackView = UIStackView()
    private let watchButton = CustomButton(style: .gradient)

    var onTap: ((Bool) -> Void)?

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Setup
    private func setupViews() {
        configureImageView()
        configureVignetteView()
        configureWatchButton()
        configureTitleLabel()
        configureButtonsStackView()
        setupGestureRecognizers()
    }

    private func setupGestureRecognizers() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
        vignetteView.isUserInteractionEnabled = true
        vignetteView.addGestureRecognizer(tapGesture)
    }

    // MARK: - Configuration
    func configure(with movie: StoriesMovieData) {
        let posterURL = movie.posterURL
        imageView.kf.setImage(with: URL(string: posterURL))
        titleLabel.text = movie.name

        configureGenres(for: movie)
    }

    private func configureGenres(for movie: StoriesMovieData) {
        genreButtonsStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }

        let filteredGenres = movie.genres.filter { $0.lowercased() != "мультфильм" }
        let genresToDisplay = Array(filteredGenres.prefix(3)).sorted { $0.count < $1.count }

        let firstTwoGenresStackView = createGenresStackView(with: genresToDisplay.prefix(2))
        let thirdGenreStackView = createGenresStackView(with: genresToDisplay.dropFirst(2))

        genreButtonsStackView.addArrangedSubview(firstTwoGenresStackView)
        genreButtonsStackView.addArrangedSubview(thirdGenreStackView)
    }

    private func createGenresStackView(with genres: ArraySlice<String>) -> UIStackView {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 4
        stackView.distribution = .fillEqually

        for genre in genres {
            let button = CustomButton(style: .plain)
            button.contentEdgeInsets = UIEdgeInsets(top: 4, left: 12, bottom: 4, right: 12)
            button.snp.makeConstraints { make in
                make.height.equalTo(28)
            }
            button.setTitle(genre, for: .normal)
            button.addTarget(self, action: #selector(genreButtonTapped(_:)), for: .touchUpInside)
            stackView.addArrangedSubview(button)
        }
        return stackView
    }

    private func configureImageView() {
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = Constants.imageCornerRadius
        imageView.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        imageView.layer.masksToBounds = true

        contentView.addSubview(imageView)

        imageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }

    private func configureVignetteView() {
        vignetteView.backgroundColor = .black.withAlphaComponent(0.4)
        vignetteView.clipsToBounds = true
        vignetteView.layer.cornerRadius = Constants.imageCornerRadius
        vignetteView.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        vignetteView.layer.masksToBounds = true

        contentView.addSubview(vignetteView)

        vignetteView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }

    private func configureTitleLabel() {
        titleLabel.textColor = .textDefault
        titleLabel.font = UIFont(name: "Manrope-Bold", size: 36)
        titleLabel.textAlignment = .left
        titleLabel.numberOfLines = 0

        contentView.addSubview(titleLabel)

        titleLabel.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(24)
            make.bottom.equalToSuperview().offset(-92)
        }
    }

    private func configureButtonsStackView() {
        genreButtonsStackView.axis = .vertical
        genreButtonsStackView.spacing = 4

        contentView.addSubview(genreButtonsStackView)

        genreButtonsStackView.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(24)
            make.trailing.equalTo(watchButton.snp.leading).offset(-16)
            make.top.equalTo(titleLabel.snp.bottom).offset(8)
        }
    }

    private func configureWatchButton() {
        watchButton.setTitle(LocalizedString.Movies.watchButtonTitle, for: .normal)
        watchButton.contentEdgeInsets = UIEdgeInsets(top: 0, left: 24, bottom: 0, right: 24)

        contentView.addSubview(watchButton)

        watchButton.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(24)
            make.bottom.equalToSuperview().offset(-24)
        }
    }

    // MARK: - Gesture Handling
    @objc private func handleTap(_ gesture: UITapGestureRecognizer) {
        let location = gesture.location(in: imageView)
        let midX = imageView.bounds.midX

        if location.x > midX {
            onTap?(true)
        } else {
            onTap?(false)
        }
    }

    // MARK: - Button Actions
    @objc private func genreButtonTapped(_ sender: CustomButton) {
        sender.toggleStyle(sender.getCurrentStyle() == .plain ? .gradient : .plain)
    }
}

// MARK: - Constants
extension MovieCell {
    enum Constants {
        static var imageCornerRadius: CGFloat = 32
    }
}
