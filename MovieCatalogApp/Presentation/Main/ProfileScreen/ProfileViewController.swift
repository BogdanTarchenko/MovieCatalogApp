//
//  ProfileViewController.swift
//  MovieCatalogApp
//
//  Created by Богдан Тарченко on 19.10.2024.
//

import UIKit
import SnapKit

final class ProfileViewController: UIViewController {
    
    private var viewModel: ProfileViewModel
    
    private let loaderView = LoaderView()
    
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    
    private let backgroundImageView = UIImageView()
    
    private let profileInformationContainer = UIView()
    private let profileImageView = UIImageView()
    
    private let greetingStackView = UIStackView()
    private let timeLabel = UILabel()
    private let nameLabel = UILabel()
    private let logoutButton = UIButton()

    private let friendsButton = UIButton()
    
    init(viewModel: ProfileViewModel) {
        self.viewModel = viewModel
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
        
        Task {
            try await viewModel.changeUserData()
        }
    }
}

private extension ProfileViewController {
    
    func bindToViewModel() {
        
        viewModel.onDidLoadUserData = { [weak self] userData in
            DispatchQueue.main.async {
                self?.configureProfileInformationContainer()
            }
        }
        
        viewModel.onPresentAlert = { [weak self] title, message in
            self?.presentInputAlert(title: title, message: message)
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
    
    func setup() {
        setupScrollView()
        setupContentView()
        setupLoaderView()
        setupView()
    }
    
    func setupLoaderView() {
        loaderView.isHidden = true
        
        view.addSubview(loaderView)
        
        loaderView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.size.equalTo(100)
        }
    }
    
    func setupScrollView() {
        view.addSubview(scrollView)
        scrollView.snp.makeConstraints { make in
            make.leading.trailing.top.equalToSuperview()
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
        }
    }
    
    func setupContentView() {
        scrollView.addSubview(contentView)
        contentView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.size.equalTo(scrollView)
        }
        
        setupContent()
    }
    
    func setupView() {
        view.backgroundColor = .background
    }
    
    func setupContent() {
        configureBackgroundImageView()
        configureProfileInformationContainer()
        configureFriendsButton()
    }
    
    func configureBackgroundImageView() {
        backgroundImageView.image = UIImage(named: "profile_background")
        backgroundImageView.contentMode = .scaleAspectFill
        backgroundImageView.clipsToBounds = true
        backgroundImageView.layer.cornerRadius = Constants.backgroundImageCornerRadius
        backgroundImageView.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        backgroundImageView.layer.masksToBounds = true
        
        contentView.addSubview(backgroundImageView)
        
        backgroundImageView.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
        }
    }
    
    func configureProfileInformationContainer() {
        contentView.addSubview(profileInformationContainer)
        profileInformationContainer.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(Constants.horizontalInset)
            make.top.equalTo(backgroundImageView.snp.bottom).offset(-48)
            make.height.equalTo(Constants.imageViewSize)
        }
        
        configureProfileImageView()
        configureLogoutButton()
        configureGreetingStackView()
    }
    
    func configureProfileImageView() {
        if let profileImageURL = URL(string: self.viewModel.userData.profileImageURL) {
            self.profileImageView.kf.setImage(with: profileImageURL)
        }
        
        profileImageView.contentMode = .scaleAspectFit
        profileImageView.layer.cornerRadius = Constants.imageViewSize / 2
        profileImageView.clipsToBounds = true
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(profileImageTapped))
        profileImageView.addGestureRecognizer(tapGesture)
        profileImageView.isUserInteractionEnabled = true
        
        profileInformationContainer.addSubview(profileImageView)
        
        profileImageView.snp.makeConstraints { make in
            make.leading.top.bottom.equalToSuperview()
            make.width.equalTo(profileImageView.snp.height)
        }
    }
    
    func configureGreetingStackView() {
        greetingStackView.addArrangedSubview(timeLabel)
        timeLabel.text = viewModel.getCurrentGreeting()
        timeLabel.font = UIFont(name: "Manrope-Medium", size: 16)
        timeLabel.textColor = .textDefault
        
        greetingStackView.addArrangedSubview(nameLabel)
        nameLabel.text = viewModel.userData.name
        nameLabel.font = UIFont(name: "Manrope-Bold", size: 24)
        nameLabel.textColor = .textDefault
        
        greetingStackView.spacing = 0
        greetingStackView.axis = .vertical
        
        profileInformationContainer.addSubview(greetingStackView)
        
        greetingStackView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalTo(profileImageView.snp.trailing).offset(16)
            make.trailing.equalTo(logoutButton.snp.leading).offset(-16)
        }
    }
    
    func configureLogoutButton() {
        logoutButton.setImage(UIImage(named: "logout"), for: .normal)
        logoutButton.addTarget(self, action: #selector(logoutButtonTapped), for: .touchUpInside)
        
        profileInformationContainer.addSubview(logoutButton)
        
        logoutButton.snp.makeConstraints { make in
            make.trailing.equalToSuperview()
            make.centerY.equalToSuperview()
        }
    }
    
    func configureFriendsButton() {
        friendsButton.setTitle(LocalizedString.Profile.friends, for: .normal)
        friendsButton.backgroundColor = .darkFaded
        
    }
    
    func presentInputAlert(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        alertController.addTextField { textField in
            textField.placeholder = LocalizedString.Alert.changeProfileImagePlaceholder
        }
        
        let confirmAction = UIAlertAction(title: LocalizedString.Alert.OK, style: .default) { _ in
            if let inputText = alertController.textFields?.first?.text {
                self.viewModel.updateProfileImage(with: inputText)
            }
        }
        
        let cancelAction = UIAlertAction(title: LocalizedString.Alert.cancel, style: .cancel)
        
        alertController.addAction(confirmAction)
        alertController.addAction(cancelAction)
        
        present(alertController, animated: true)
    }
    
    @objc func profileImageTapped() {
        presentInputAlert(title: LocalizedString.Alert.changeProfileImageTitle, message: SC.empty)
    }
    
    @objc func logoutButtonTapped() {
        viewModel.onLogoutButtonTapped()
    }
}

// MARK: - Constants
private extension ProfileViewController {
    enum Constants {
        static let backgroundImageCornerRadius: CGFloat = 32
        static let horizontalInset: CGFloat = 24
        static let imageViewSize: CGFloat = 96
    }
}
