//
//  MoviesViewController.swift
//  MovieCatalogApp
//
//  Created by Богдан Тарченко on 19.10.2024.
//

import UIKit
import Kingfisher
import SnapKit

class MoviesViewController: UIViewController {

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
    }

    // MARK: - Setup
    private func setup() {
        setupScrollView()
        setupContentView()
        setupLoaderView()
        setupView()
        collectionView.isScrollEnabled = false
    }

    private func setupScrollView() {
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
        if let tabBar = tabBarController?.tabBar {
            tabBar.backgroundImage = UIImage()
        }
    }

    private func setupContent() {
        setupCollectionView()
        setupProgressBar()
        setupRandomMovieButton()
    }

    private func setupCollectionView() {
        collectionView.backgroundColor = .clear
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(MovieCell.self, forCellWithReuseIdentifier: "MovieCell")
        
        contentView.addSubview(collectionView)
        collectionView.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
            make.height.equalTo(464)
            make.bottom.equalToSuperview()
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
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(8)
        }
    }
    
    private func setupRandomMovieButton() {
        contentView.addSubview(randomMovieButton)
        
        randomMovieButton.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(24)
            make.top.equalTo(collectionView.snp.bottom).offset(32)
            make.height.equalTo(96)
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

    deinit {
        timer?.invalidate()
    }
}

// MARK: - Binding
extension MoviesViewController {
    private func bindToViewModel() {
        viewModel.onDidLoadStoriesMovieData = { [weak self] storiesMovieData in
            DispatchQueue.main.async {
                self?.collectionView.reloadData()
                self?.progressBar.isPaused = false
                self?.startTimer()
            }
        }
        
        viewModel.onDidStartLoad = { [weak self] in
            self?.loaderView.isHidden = false
            self?.loaderView.startAnimating()
        }
        
        viewModel.onDidFinishLoad = { [weak self] in
            self?.loaderView.isHidden = true
            self?.loaderView.finishAnimating()
        }
    }
}

// MARK: - UICollectionViewDelegateFlowLayout, UICollectionViewDataSource
extension MoviesViewController: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.storiesMovieData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MovieCell", for: indexPath) as! MovieCell
        let movie = viewModel.storiesMovieData[indexPath.row]
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
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: collectionView.frame.height)
    }
}

// MARK: - SegmentedProgressBarDelegate
extension MoviesViewController: SegmentedProgressBarDelegate {
    func segmentedProgressBarChangedIndex(index: Int) {}
    func segmentedProgressBarFinished() {}
}
