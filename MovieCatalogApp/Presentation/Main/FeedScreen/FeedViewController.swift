//
//  FeedViewController.swift
//  MovieCatalogApp
//
//  Created by Богдан Тарченко on 19.10.2024.
//

import UIKit
import SnapKit
import Kingfisher

final class FeedViewController: UIViewController {
    
    private var viewModel: FeedViewModel
    
    private let logoImageView = UIImageView()
    private let movieDataContainer = UIView()
    private let stackView = UIStackView()
    private let countryYearLabel = UILabel()
    private let movieTitleLabel = UILabel()
    private let moviePoster = UIImageView()
    private let emptyMovieImageView = UIImageView()
    
    private var panGesture: UIPanGestureRecognizer!
    
    init(viewModel: FeedViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(updateUI), name: .didLoadMovies, object: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadInitialMovies()
        setup()
        setupSwipeGestures()
    }
    
    // MARK: - Setup Swipe
    private func setupSwipeGestures() {
        panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePanGesture(_:)))
        moviePoster.isUserInteractionEnabled = true
        moviePoster.addGestureRecognizer(panGesture)
    }
    
    // MARK: - Swipe Handling
    @objc private func handlePanGesture(_ gesture: UIPanGestureRecognizer) {
        let translation = gesture.translation(in: view)
        let velocity = gesture.velocity(in: view)
        
        switch gesture.state {
        case .changed:
            moviePoster.transform = CGAffineTransform(translationX: translation.x, y: .zero)
            
            showSwipeIndicator(isLike: translation.x > .zero)
            
        case .ended:
            if abs(translation.x) > Constants.Swipe.translationThreshold {
                if velocity.x > .zero {
                    handleSwipeRight()
                } else {
                    handleSwipeLeft()
                }
            } else {
                resetPosterPosition()
            }
            hideSwipeIndicators()
            
        default:
            break
        }
    }
    
    private func handleSwipeRight() {
        showSwipeIndicator(isLike: true)
        animateCardSwipe(to: Constants.Swipe.offScreenRight)
    }
    
    private func handleSwipeLeft() {
        showSwipeIndicator(isLike: false)
        animateCardSwipe(to: Constants.Swipe.offScreenLeft)
    }
    
    private func showSwipeIndicator(isLike: Bool) {
        if moviePoster.subviews.contains(where: { $0.tag == Constants.Overlay.tag }) {
            return
        }
        
        let overlayView = UIView()
        overlayView.backgroundColor = isLike ? .like : .dislike
        overlayView.tag = Constants.Overlay.tag
        
        let imageName = isLike ? Constants.Images.like : Constants.Images.dislike
        let imageView = UIImageView(image: UIImage(named: imageName))
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = .textDefault
        
        overlayView.addSubview(imageView)
        moviePoster.addSubview(overlayView)
        
        overlayView.snp.makeConstraints { make in
            make.edges.equalTo(moviePoster)
        }
        
        imageView.snp.makeConstraints { make in
            make.center.equalTo(overlayView)
            make.width.height.equalTo(moviePoster.snp.height).dividedBy(4)
        }
    }
    
    private func hideSwipeIndicators() {
        moviePoster.subviews.forEach { subview in
            if subview.tag == Constants.Overlay.tag {
                subview.removeFromSuperview()
            }
        }
    }
    
    private func animateCardSwipe(to x: CGFloat) {
        UIView.animate(withDuration: Constants.Animation.duration, animations: {
            self.moviePoster.transform = CGAffineTransform(translationX: x, y: .zero)
        }) { [weak self] _ in
            Task {
                await self?.loadNextMovie()
            }
        }
    }
    
    private func resetPosterPosition() {
        UIView.animate(withDuration: Constants.Animation.duration) {
            self.moviePoster.transform = .identity
        }
    }
    
    private func loadInitialMovies() {
        Task {
            await viewModel.loadInitialMovies()
        }
    }
    
    private func loadNextMovie() async {
        if let movie = await viewModel.fetchNextMovie() {
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                self.viewModel.currentMovieData = movie
                self.updateUI()
                self.resetPosterPosition()
                print(movie.name)
            }
        } else {
            DispatchQueue.main.async { [weak self] in
                self?.showEmptyMovieImage()
            }
            print("Не удалось загрузить следующий фильм")
        }
    }
    
    private func showEmptyMovieImage() {
        emptyMovieImageView.image = UIImage(named: "empty_movie")
        emptyMovieImageView.contentMode = .scaleAspectFill
        emptyMovieImageView.layer.cornerRadius = Constants.MoviePoster.cornerRadius
        emptyMovieImageView.clipsToBounds = true
        movieDataContainer.addSubview(emptyMovieImageView)
        
        emptyMovieImageView.snp.makeConstraints { make in
            make.leading.trailing.top.equalToSuperview()
            make.bottom.equalTo(movieTitleLabel.snp.top).offset(Constants.MoviePoster.bottomOffset)
        }
        
        moviePoster.isHidden = true
        stackView.isHidden = true
        countryYearLabel.isHidden = true
        
        movieTitleLabel.text = LocalizedString.Feed.emptyMovie
        
        emptyMovieImageView.alpha = 0
        
        UIView.animate(withDuration: 0.5) {
            self.emptyMovieImageView.alpha = 1
        }
    }
    
    // MARK: - UI Setup
    private func setup() {
        setupView()
        configureUI()
    }
    
    private func setupView() {
        view.backgroundColor = .background
    }
    
    private func configureUI() {
        configureLogoImageView()
        configureMovieDataContainerView()
        configureStackView()
    }
    
    // MARK: - UI Update
    @objc private func updateUI() {
        configureButtons()
        configureCountryYearLabel()
        configureMovieTitleLabel()
        configureMoviePoster()
    }
    
    
    // MARK: - Configure UI
    private func configureLogoImageView() {
        logoImageView.image = UIImage(named: Constants.LogoImageView.logoImageName)
        logoImageView.contentMode = .scaleAspectFit
        
        view.addSubview(logoImageView)
        
        logoImageView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(view.safeAreaLayoutGuide).offset(Constants.LogoImageView.topOffset)
        }
    }
    
    private func configureMovieDataContainerView() {
        view.addSubview(movieDataContainer)
        
        movieDataContainer.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(Constants.MovieDataContainer.horizontalInset)
            make.top.equalTo(logoImageView.snp.bottom).offset(Constants.MovieDataContainer.topOffset)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(Constants.MovieDataContainer.bottomOffset)
        }
    }
    
    private func configureStackView() {
        stackView.axis = .horizontal
        stackView.spacing = Constants.StackView.spacing
        
        movieDataContainer.addSubview(stackView)
        
        stackView.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalToSuperview()
            make.height.equalTo(Constants.StackView.height)
        }
    }
    
    private func configureButtons() {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            
            self.stackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
            
            let genres = self.viewModel.currentMovieData.genres
            let horizontalPadding = Constants.GenreButton.horizontalPadding
            let verticalPadding = Constants.GenreButton.verticalPadding
            
            let stackViewWidth = self.stackView.frame.width
            
            var totalWidth: CGFloat = 0
            
            for genre in genres {
                let genreButton = CustomButton(style: .plain)
                genreButton.setTitle(genre, for: .normal)
                genreButton.titleLabel?.lineBreakMode = .byTruncatingMiddle
                
                var config = UIButton.Configuration.plain()
                config.title = genre
                config.contentInsets = NSDirectionalEdgeInsets(top: verticalPadding, leading: horizontalPadding, bottom: verticalPadding, trailing: horizontalPadding)
                
                genreButton.addTarget(self, action: #selector(self.buttonTapped(sender:)), for: .touchUpInside)
                
                genreButton.configuration = config
                
                genreButton.sizeToFit()
                
                let buttonWidth = genreButton.intrinsicContentSize.width + horizontalPadding * 2
                
                if totalWidth + buttonWidth <= stackViewWidth {
                    totalWidth += buttonWidth
                    self.stackView.addArrangedSubview(genreButton)
                } else {
                    break
                }
            }
            
            self.stackView.layoutIfNeeded()
        }
    }
    
    private func configureCountryYearLabel() {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            
            self.countryYearLabel.text = "\(self.viewModel.currentMovieData.country) • \(self.viewModel.currentMovieData.year)"
            self.countryYearLabel.font = UIFont(name: Constants.Fonts.FontNames.medium, size: Constants.Fonts.FontSizes.medium)
            self.countryYearLabel.textColor = .textInformation
            
            self.movieDataContainer.addSubview(self.countryYearLabel)
            
            self.countryYearLabel.snp.makeConstraints { make in
                make.centerX.equalToSuperview()
                make.bottom.equalTo(self.stackView.snp.top).offset(Constants.CountryYearLabel.bottomOffset)
            }
        }
    }
    
    private func configureMovieTitleLabel() {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            
            self.movieTitleLabel.text = self.viewModel.currentMovieData.name
            self.movieTitleLabel.font = UIFont(name: Constants.Fonts.FontNames.bold, size: Constants.Fonts.FontSizes.large)
            self.movieTitleLabel.textColor = .textDefault
            self.movieTitleLabel.textAlignment = .center
            self.movieTitleLabel.numberOfLines = 0
            
            self.movieDataContainer.addSubview(self.movieTitleLabel)
            
            self.movieTitleLabel.snp.makeConstraints { make in
                make.centerX.equalToSuperview()
                make.bottom.equalTo(self.countryYearLabel.snp.top).offset(Constants.MovieTitleLabel.bottomOffset)
                make.leading.trailing.equalToSuperview()
            }
        }
    }
    
    private func configureMoviePoster() {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            
            if let posterURL = URL(string: self.viewModel.currentMovieData.posterURL) {
                self.moviePoster.kf.setImage(with: posterURL)
            }
            
            self.moviePoster.contentMode = .scaleAspectFill
            self.moviePoster.layer.cornerRadius = Constants.MoviePoster.cornerRadius
            self.moviePoster.clipsToBounds = true
            
            self.movieDataContainer.addSubview(self.moviePoster)
            
            self.moviePoster.snp.makeConstraints { make in
                make.leading.trailing.top.equalToSuperview()
                make.bottom.equalTo(self.movieTitleLabel.snp.top).offset(Constants.MoviePoster.bottomOffset)
            }
        }
    }
    
    // MARK: - Button Action
    @objc private func buttonTapped(sender: CustomButton) {
        sender.toggleStyle(.gradient)
        // TODO: - добавить проверку на избранное
    }
}

// MARK: - Constants
private extension FeedViewController {
    enum Constants {
        enum Swipe {
            static let translationThreshold: CGFloat = 100
            static let offScreenRight: CGFloat = 500
            static let offScreenLeft: CGFloat = -500
        }
        
        enum Images {
            static let like = "like"
            static let dislike = "dislike"
        }
        
        enum Animation {
            static let duration: TimeInterval = 0.3
        }
        
        enum LogoImageView {
            static let topOffset: CGFloat = 24
            static let logoImageName = "logo"
        }
        
        enum MovieDataContainer {
            static let horizontalInset: CGFloat = 24
            static let topOffset: CGFloat = 24
            static let bottomOffset: CGFloat = -56
        }
        
        enum StackView {
            static let spacing: CGFloat = 4
            static let height: CGFloat = 28
        }
        
        enum CountryYearLabel {
            static let bottomOffset: CGFloat = -8
        }
        
        enum MovieTitleLabel {
            static let bottomOffset: CGFloat = -8
        }
        
        enum MoviePoster {
            static let cornerRadius: CGFloat = 8
            static let bottomOffset: CGFloat = -16
        }
        
        enum GenreButton {
            static let horizontalPadding: CGFloat = 12
            static let verticalPadding: CGFloat = 8
        }
        
        enum Fonts {
            enum FontNames {
                static let medium = "Manrope-Medium"
                static let bold = "Manrope-Bold"
            }
            enum FontSizes {
                static let medium: CGFloat = 16
                static let large: CGFloat = 24
            }
        }
        
        enum Overlay {
            static let tag: Int = 999
        }
    }
}
