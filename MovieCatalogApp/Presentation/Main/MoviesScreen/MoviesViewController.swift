//
//  MoviesViewController.swift
//  MovieCatalogApp
//
//  Created by Богдан Тарченко on 19.10.2024.
//

import UIKit
import Kingfisher
import SnapKit
import SwiftUI

final class MoviesViewController: UIViewController {
    
    private var viewModel: MoviesViewModel
    private let loaderView = LoaderView()
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    
    private let collectionView: UICollectionView
    private let progressBar = SegmentedProgressBar(numberOfSegments: 5, duration: 5, gradientColors: [
        UIColor(red: 223/255, green: 40/255, blue: 0/255, alpha: 1).cgColor,
        UIColor(red: 255/255, green: 102/255, blue: 51/255, alpha: 1).cgColor
    ])
    
    private let randomMovieButton = RandomMovieButton(title: LocalizedString.Movies.randomMovieButtonTitle)
    
    private let favoritesLabelStackView = UIStackView()
    private let carousel = CarouselView(withFrame: .zero, andInset: 8)
    
    private let allMoviesLabel = GradientLabel()
    private let allMoviesCollectionView: UICollectionView
    
    private var lastFetchedRow: Int = -1
    private var timer: Timer?
    private var lastTapTime: TimeInterval = 0
    private let tapDelay: TimeInterval = 0.4
    private var isAnimating = false
    private var isFirstAppearance = true
    
    init(viewModel: MoviesViewModel) {
        self.viewModel = viewModel
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 0
        self.collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        
        let allMovieLayout = UICollectionViewFlowLayout()
        allMovieLayout.scrollDirection = .vertical
        allMovieLayout.minimumInteritemSpacing = 8
        allMovieLayout.minimumLineSpacing = 8
        self.allMoviesCollectionView = UICollectionView(frame: .zero, collectionViewLayout: allMovieLayout)
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        bindToViewModel()
        viewModel.onDidLoad()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        stopTimer()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if isFirstAppearance {
            isFirstAppearance = false
            return
        }
        
        startTimer()
        progressBar.continueAnimation()
        
        Task {
            await viewModel.onDidUpdateFavorites()
            carousel.reloadData()
            allMoviesCollectionView.reloadData()
        }
    }
    
    // MARK: - Setup
    private func setup() {
        setupScrollView()
        setupContentView()
        setupLoaderView()
        setupView()
    }
    
    private func setupScrollView() {
        self.scrollView.delegate = self
        view.addSubview(scrollView)
        scrollView.contentInsetAdjustmentBehavior = .never
        scrollView.backgroundColor = .clear
        scrollView.snp.makeConstraints { make in
            make.leading.trailing.top.equalToSuperview()
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
        }
    }
    
    private func setupContentView() {
        scrollView.addSubview(contentView)
        contentView.snp.makeConstraints { make in
            make.top.bottom.leading.trailing.equalToSuperview()
            make.width.equalToSuperview()
        }
        setupContent()
    }
    
    private func setupLoaderView() {
        loaderView.isHidden = true
        view.addSubview(loaderView)
        loaderView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.size.equalTo(100)
        }
    }
    
    private func setupView() {
        view.backgroundColor = .background
    }
    
    private func setupContent() {
        setupCollectionView()
        setupProgressBar()
        setupRandomMovieButton()
        setupFavoritesStackView()
        setupCarousel()
        setupGradientLabel()
        setupAllMoviewCollectionView()
    }
    
    private func setupCollectionView() {
        collectionView.isScrollEnabled = false
        collectionView.backgroundColor = .clear
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(MovieCell.self, forCellWithReuseIdentifier: "MovieCell")
        
        contentView.addSubview(collectionView)
        collectionView.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
            make.height.equalTo(464)
        }
    }
    
    private func setupProgressBar() {
        progressBar.frame = CGRect(x: 0, y: 0, width: view.frame.width - 48, height: 4)
        progressBar.delegate = self
        progressBar.bottomColor = UIColor(.textInformation)
        progressBar.startAnimation()
        progressBar.isPaused = true
        
        contentView.addSubview(progressBar)
        progressBar.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(24)
            make.top.equalToSuperview().offset(60)
        }
    }
    
    private func setupRandomMovieButton() {
        randomMovieButton.isUserInteractionEnabled = true
        randomMovieButton.action = {
            self.randomMovieButtonTapped()
        }
        
        contentView.addSubview(randomMovieButton)
        
        randomMovieButton.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(24)
            make.top.equalTo(collectionView.snp.bottom).offset(32)
            make.height.equalTo(96)
        }
    }
    
    private func setupFavoritesStackView() {
        favoritesLabelStackView.axis = .horizontal
        favoritesLabelStackView.distribution = .fill
        
        let favoritesLabel: GradientLabel = {
            let label = GradientLabel()
            label.text = LocalizedString.Movies.favoritesLabel
            return label
        }()
        
        let allButton: UIButton = {
            let button = UIButton()
            button.setTitle(LocalizedString.Movies.allButtonTitle, for: .normal)
            button.titleLabel?.font = UIFont(name: "Manrope-Bold", size: 20)
            button.setTitleColor(.textInformation, for: .normal)
            button.backgroundColor = .clear
            button.addTarget(self, action: #selector(allButtonTapped), for: .touchUpInside)
            return button
        }()
        
        favoritesLabelStackView.addArrangedSubview(favoritesLabel)
        favoritesLabelStackView.addArrangedSubview(UIView())
        favoritesLabelStackView.addArrangedSubview(allButton)
        
        contentView.addSubview(favoritesLabelStackView)
        
        favoritesLabelStackView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(24)
            make.top.equalTo(randomMovieButton.snp.bottom).offset(32)
        }
    }
    
    func setupCarousel() {
        carousel.backgroundColor = .clear
        carousel.delegate = self
        carousel.dataSource = self
        carousel.register(FavoritesMovieCell.self, forCellWithReuseIdentifier: "FavoritesMovieCell")
        
        carousel.showsHorizontalScrollIndicator = false
        
        contentView.addSubview(carousel)
        carousel.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(favoritesLabelStackView.snp.bottom).offset(16)
            make.height.equalTo(252)
            
        }
    }
    
    func setupGradientLabel() {
        allMoviesLabel.text = LocalizedString.Movies.allMoviesLabel
        
        contentView.addSubview(allMoviesLabel)
        
        allMoviesLabel.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(24)
            make.top.equalTo(carousel.snp.bottom).offset(32)
        }
    }
    
    func setupAllMoviewCollectionView() {
        allMoviesCollectionView.isScrollEnabled = false
        allMoviesCollectionView.backgroundColor = .clear
        allMoviesCollectionView.delegate = self
        allMoviesCollectionView.dataSource = self
        allMoviesCollectionView.register(MoviePosterCell.self, forCellWithReuseIdentifier: "MoviePosterCell")
        
        contentView.addSubview(allMoviesCollectionView)
        
        allMoviesCollectionView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(24)
            make.top.equalTo(allMoviesLabel.snp.bottom).offset(16)
            make.height.equalTo(0)
            make.bottom.equalToSuperview().inset(32)
        }
    }
    
    // MARK: - Timer
    private func startTimer() {
        guard timer == nil else { return }
        timer = Timer.scheduledTimer(withTimeInterval: 5.0, repeats: true) { [weak self] _ in
            self?.scrollToNextItem()
        }
    }
    
    private func stopTimer() {
        timer?.invalidate()
        timer = nil
    }
    
    // MARK: - Scrolling
    private func scrollToNextItem() {
        guard !isAnimating else { return }
        isAnimating = true
        let visibleItems = collectionView.indexPathsForVisibleItems
        guard let currentIndex = visibleItems.first?.row else { return }
        
        let nextIndex = (currentIndex + 1) % viewModel.storiesMovieData.count
        collectionView.scrollToItem(at: IndexPath(row: nextIndex, section: 0), at: .centeredHorizontally, animated: true)
        
        progressBar.delegate?.segmentedProgressBarChangedIndex(index: nextIndex)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.isAnimating = false
        }
    }
    
    private func scrollToPreviousItem() {
        guard !isAnimating else { return }
        isAnimating = true
        let visibleItems = collectionView.indexPathsForVisibleItems
        guard let currentIndex = visibleItems.first?.row else { return }
        
        let nextIndex = max(currentIndex - 1, 0)
        collectionView.scrollToItem(at: IndexPath(row: nextIndex, section: 0), at: .centeredHorizontally, animated: true)
        
        progressBar.delegate?.segmentedProgressBarChangedIndex(index: nextIndex)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.isAnimating = false
        }
    }
    
    // MARK: Update AllMoviesCollectionViewHeight
    private func updateCollectionViewHeight() {
        let collectionViewHeight = calculateCollectionViewHeight()
        allMoviesCollectionView.snp.updateConstraints { make in
            make.height.equalTo(collectionViewHeight)
        }
        view.layoutIfNeeded()
    }
    
    private func calculateCollectionViewHeight() -> CGFloat {
        let numberOfItems = viewModel.allMovieData.count
        let itemHeight: CGFloat = 166
        let spacing: CGFloat = 8
        
        let rows = ceil(CGFloat(numberOfItems) / 3.0)
        let totalHeight = (itemHeight * rows) + (spacing * (rows - 1))
        return totalHeight
    }
    
    // MARK: Button Actions
    private func randomMovieButtonTapped() {
        var combinedMovies: [String] = []
        
        viewModel.allMovieData.forEach { movie in
            combinedMovies.append(movie.id)
        }
        viewModel.storiesMovieData.forEach { movie in
            combinedMovies.append(movie.id)
        }
        
        let movieDetailsViewModel = MovieDetailsViewModel(movieID: combinedMovies.randomElement() ?? SC.empty)
        movieDetailsViewModel.onDismiss = { [weak self] in
            self?.dismiss(animated: true)
        }

        let movieDetailsView = MovieDetailsView(viewModel: movieDetailsViewModel)
        let hostingController = UIHostingController(rootView: movieDetailsView)
        let navigationController = UINavigationController(rootViewController: hostingController)
        navigationController.modalPresentationStyle = .fullScreen

        self.present(navigationController, animated: true)
    }
    @objc private func allButtonTapped() {
        viewModel.onDidAllButtonTapped()
    }
    
    deinit {
        timer?.invalidate()
    }
}

// MARK: - Binding
extension MoviesViewController {
    private func bindToViewModel() {
        viewModel.onDidLoadStoriesMovieData = { [weak self] storiesMovieData in
            self?.collectionView.reloadData()
            self?.progressBar.isPaused = false
            self?.startTimer()
        }
        
        viewModel.onDidLoadFavoritesMovieData = { [weak self] favoritesMovieData in
            self?.carousel.reloadData()
        }
        
        viewModel.onDidLoadAllMovieData = { [weak self] allMovieData in
            self?.allMoviesCollectionView.reloadData()
            self?.updateCollectionViewHeight()
        }
        
        viewModel.onDidStartLoad = { [weak self] in
            guard let self = self else { return }
            
            let dimmingView = UIView(frame: self.view.bounds)
            dimmingView.backgroundColor = UIColor.black.withAlphaComponent(0.0)
            dimmingView.tag = 999
            self.view.addSubview(dimmingView)
            
            UIView.animate(withDuration: 0.3) {
                dimmingView.backgroundColor = UIColor.black.withAlphaComponent(0.5)
            }
            
            self.loaderView.isHidden = false
            self.loaderView.startAnimating()
            self.view.isUserInteractionEnabled = false
        }
        
        viewModel.onDidFinishLoad = { [weak self] in
            guard let self = self else { return }
            
            if let dimmingView = self.view.viewWithTag(999) {
                UIView.animate(withDuration: 0.3, animations: {
                    dimmingView.backgroundColor = UIColor.black.withAlphaComponent(0.0)
                }) { _ in
                    dimmingView.removeFromSuperview()
                }
            }
            
            self.loaderView.isHidden = true
            self.loaderView.finishAnimating()
            self.view.isUserInteractionEnabled = true
        }
    }
}

// MARK: - UICollectionViewDelegateFlowLayout, UICollectionViewDataSource
extension MoviesViewController: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == self.collectionView {
            return viewModel.storiesMovieData.count
        }
        else if collectionView == self.carousel {
            return viewModel.favoritesMovieData.count
        }
        else if collectionView == self.allMoviesCollectionView {
            return viewModel.allMovieData.count
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        // MARK: - CollectionView
        if collectionView == self.collectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MovieCell", for: indexPath) as! MovieCell
            let movie = viewModel.storiesMovieData[indexPath.row]
            
            cell.currentUserId = viewModel.currentUserId
            
            cell.action = { [weak self] in
                guard let self = self else { return }
                
                let movieDetailsViewModel = MovieDetailsViewModel(movieID: movie.id)
                movieDetailsViewModel.onDismiss = { [weak self] in
                    self?.dismiss(animated: true)
                }
                
                let movieDetailsView = MovieDetailsView(viewModel: movieDetailsViewModel)
                let hostingController = UIHostingController(rootView: movieDetailsView)
                let navigationController = UINavigationController(rootViewController: hostingController)
                navigationController.modalPresentationStyle = .fullScreen
                
                self.present(navigationController, animated: true)
            }
            
            cell.configure(with: movie)
            
            cell.onTap = { [weak self] isNext in
                guard let self = self else { return }
                let currentTime = Date().timeIntervalSince1970
                
                if currentTime - self.lastTapTime < self.tapDelay || self.isAnimating {
                    return
                }
                
                self.lastTapTime = currentTime
                
                if isNext {
                    self.scrollToNextItem()
                    self.progressBar.skip()
                } else {
                    self.scrollToPreviousItem()
                    self.progressBar.rewind()
                }
                
                self.stopTimer()
                self.startTimer()
            }
            
            return cell
        }
        
        // MARK: - Carousel
        else if collectionView == self.carousel {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FavoritesMovieCell", for: indexPath) as! FavoritesMovieCell
            let favoriteMovie = viewModel.favoritesMovieData[indexPath.row]
            cell.configure(with: favoriteMovie)
            
            cell.setNeedsLayout()
            cell.layoutIfNeeded()
            
            return cell
        }
        
        // MARK: - AllMovies
        else if collectionView == self.allMoviesCollectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MoviePosterCell", for: indexPath) as! MoviePosterCell
            let allMovie = viewModel.allMovieData[indexPath.row]
            cell.configure(with: allMovie)
            
            let isFavorite = viewModel.favoritesMovieData.contains { $0.id == allMovie.id }
            cell.likeButton.isHidden = !isFavorite
            
            cell.onTap = { [weak self] in
                guard let self = self else { return }
                
                let movieDetailsViewModel = MovieDetailsViewModel(movieID: allMovie.id)
                movieDetailsViewModel.onDismiss = { [weak self] in
                    self?.dismiss(animated: true)
                }
                
                let movieDetailsView = MovieDetailsView(viewModel: movieDetailsViewModel)
                let hostingController = UIHostingController(rootView: movieDetailsView)
                let navigationController = UINavigationController(rootViewController: hostingController)
                navigationController.modalPresentationStyle = .fullScreen
                
                self.present(navigationController, animated: true)
            }
            
            return cell
        }
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if collectionView == self.collectionView {
            return CGSize(width: collectionView.frame.width, height: collectionView.frame.height)
        }
        else if collectionView == self.carousel {
            return CGSize(width: collectionView.frame.width * 0.37, height: collectionView.frame.height / 1.07)
        }
        else if collectionView == self.allMoviesCollectionView {
            let baseHeight: CGFloat = 166
            return CGSize(width: (allMoviesCollectionView.frame.width - 16) / 3, height: baseHeight)
        }
        return CGSize(width: collectionView.frame.width, height: collectionView.frame.height)
    }
}

// MARK: - UIScrollViewDelegate
extension MoviesViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard scrollView == self.scrollView else { return }
        
        let contentOffsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        let frameHeight = scrollView.frame.size.height
        
        if contentOffsetY + frameHeight >= contentHeight - 340 {
            viewModel.onDidScrolledToEnd()
            allMoviesCollectionView.reloadData()
            updateCollectionViewHeight()
        }
    }
}

// MARK: - SegmentedProgressBarDelegate
extension MoviesViewController: SegmentedProgressBarDelegate {
    func segmentedProgressBarChangedIndex(index: Int) {}
    func segmentedProgressBarFinished() {}
}
