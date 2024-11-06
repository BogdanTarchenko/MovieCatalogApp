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
    
    private let informationStackView = UIStackView()
    private let privateInformationLabel = GradientLabel()
    private let usernameTextField = ProfileTextField(title: LocalizedString.Profile.usernameTitle, style: .information)
    private let emailTextField = ProfileTextField(title: LocalizedString.Profile.emailTitle, style: .information)
    private let nameTextField = ProfileTextField(title: LocalizedString.Profile.nameTitle, style: .information)
    private let birthDateTextField = ProfileTextField(title: LocalizedString.Profile.birthDateTitle, style: .date)
    private let genderButton = ProfileGenderButton(title: LocalizedString.Profile.genderTitle)
    
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        configureFriendAvatars()
    }
}

private extension ProfileViewController {
    
    // MARK: - Bindings
    func bindToViewModel() {
        viewModel.onDidLoadUserData = { [weak self] userData in
            DispatchQueue.main.async {
                self?.configureProfileInformationContainer()
                self?.configureInformationStackView()
                self?.configureFriendAvatars()
            }
        }
        
        viewModel.onPresentAlert = { [weak self] title, message in
            self?.presentInputAlert(title: title, message: message)
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
    
    // MARK: - Setup
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
        scrollView.contentInsetAdjustmentBehavior = .never
        scrollView.backgroundColor = .clear
        scrollView.snp.makeConstraints { make in
            make.leading.trailing.top.equalToSuperview()
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
        }
    }
    
    func setupContentView() {
        scrollView.addSubview(contentView)
        contentView.snp.makeConstraints { make in
            make.top.bottom.leading.trailing.equalToSuperview()
            make.width.equalToSuperview()
        }
        setupContent()
    }
    
    func setupView() {
        view.backgroundColor = .background
        
        if let tabBar = tabBarController?.tabBar {
            tabBar.backgroundImage = UIImage()
        }
    }
    
    func setupContent() {
        configureBackgroundImageView()
        configureProfileInformationContainer()
        configureFriendsButton()
        configureInformationStackView()
    }
    
    // MARK: - Configure
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
            self.profileImageView.kf.setImage(
                with: profileImageURL,
                placeholder: UIImage(named: Constants.defaultAvatarLink),
                completionHandler: { result in
                    switch result {
                    case .failure:
                        self.profileImageView.kf.setImage(with: URL(string: Constants.defaultAvatarLink))
                    case .success:
                        break
                    }
                }
            )
        } else {
            self.profileImageView.image = UIImage(named: Constants.defaultAvatarLink)
        }
        
        
        profileImageView.contentMode = .scaleAspectFill
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
        friendsButton.titleLabel?.font = UIFont(name: "Manrope-Medium", size: 16)
        friendsButton.titleLabel?.textColor = .textDefault
        friendsButton.titleLabel?.textAlignment = .center
        friendsButton.backgroundColor = .darkFaded
        friendsButton.addTarget(self, action: #selector(friendsButtonTapped), for: .touchUpInside)
        
        friendsButton.layer.cornerRadius = Constants.friendsButtonCornerRadius
        
        contentView.addSubview(friendsButton)
        
        friendsButton.snp.makeConstraints { make in
            make.height.equalTo(Constants.friendsButtonHeight)
            make.leading.trailing.equalToSuperview().inset(Constants.horizontalInset)
            make.top.equalTo(profileInformationContainer.snp.bottom).offset(Constants.defaultOffset)
        }
        
        print(viewModel.friendsData)
        configureFriendAvatars()
    }
    
    func configureFriendAvatars() {
        viewModel.updateFriends()
        
        friendsButton.subviews.forEach { if $0 is UIImageView { $0.removeFromSuperview() } }
        
        let avatarSize: CGFloat = 32
        let avatarCornerRadius: CGFloat = avatarSize / 2
        let avatarOffset: CGFloat = -8
        
        let maxAvatars = min(viewModel.friendsData.count, 3)
        for index in 0..<maxAvatars {
            let friend = viewModel.friendsData[index]
            
            let avatarImageView = UIImageView()
            avatarImageView.layer.cornerRadius = avatarCornerRadius
            avatarImageView.clipsToBounds = true
            avatarImageView.contentMode = .scaleAspectFill
            
            if let avatarURL = URL(string: friend.avatarLink ?? Constants.defaultAvatarLink) {
                avatarImageView.kf.setImage(
                    with: avatarURL,
                    placeholder: UIImage(named: Constants.defaultAvatarLink),
                    completionHandler: { result in
                        switch result {
                        case .failure:
                            avatarImageView.kf.setImage(with: URL(string: Constants.defaultAvatarLink))
                        case .success:
                            break
                        }
                    }
                )
            } else {
                avatarImageView.image = UIImage(named: Constants.defaultAvatarLink)
            }
            
            friendsButton.addSubview(avatarImageView)
            
            avatarImageView.snp.makeConstraints { make in
                make.size.equalTo(CGSize(width: avatarSize, height: avatarSize))
                make.centerY.equalToSuperview()
                make.leading.equalToSuperview().offset(CGFloat(index + 1) * (avatarSize + avatarOffset))
            }
        }
    }
    
    func configureInformationStackView() {
        informationStackView.addArrangedSubview(privateInformationLabel)
        informationStackView.addArrangedSubview(usernameTextField)
        informationStackView.addArrangedSubview(emailTextField)
        informationStackView.addArrangedSubview(nameTextField)
        informationStackView.addArrangedSubview(birthDateTextField)
        informationStackView.addArrangedSubview(genderButton)
        
        contentView.addSubview(informationStackView)
        informationStackView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(Constants.horizontalInset)
            make.top.equalTo(friendsButton.snp.bottom).offset(Constants.defaultOffset)
            make.bottom.equalToSuperview().inset(32)
        }
        
        informationStackView.spacing = 16
        informationStackView.axis = .vertical
        informationStackView.isUserInteractionEnabled = false
        
        privateInformationLabel.text = LocalizedString.Profile.privateInformationLabel
        
        usernameTextField.textField.text = viewModel.userData.username
        
        emailTextField.textField.text = viewModel.userData.email
        
        nameTextField.textField.text = viewModel.userData.name
        
        let isoDateFormatter = ISO8601DateFormatter()
        if let date = isoDateFormatter.date(from: (viewModel.userData.birthDate + "Z")) {
            let outputDateFormatter = DateFormatter()
            outputDateFormatter.locale = Locale(identifier: "ru_RU")
            outputDateFormatter.dateFormat = "dd MMMM yyyy"
            
            let formattedDateString = outputDateFormatter.string(from: date)
            birthDateTextField.textField.text = formattedDateString
        }
        updateGenderButtonState()
    }
    
    // MARK: - Alert
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
    
    // MARK: - Update Gender State
    private func updateGenderButtonState() {
        if viewModel.userData.gender == .male {
            genderButton.genderButton.leftButton.toggleStyle(.gradient)
            genderButton.genderButton.rightButton.toggleStyle(.plain)
        } else {
            genderButton.genderButton.rightButton.toggleStyle(.gradient)
            genderButton.genderButton.leftButton.toggleStyle(.plain)
        }
    }
    
    // MARK: - Button Actions
    @objc func profileImageTapped() {
        presentInputAlert(title: LocalizedString.Alert.changeProfileImageTitle, message: SC.empty)
    }
    
    @objc func logoutButtonTapped() {
        viewModel.onLogoutButtonTapped()
    }
    
    @objc func friendsButtonTapped() {
        viewModel.friendsButtonTapped()
    }
}

// MARK: - Constants
private extension ProfileViewController {
    enum Constants {
        static let backgroundImageCornerRadius: CGFloat = 32
        static let horizontalInset: CGFloat = 24
        static let imageViewSize: CGFloat = 96
        static let friendsButtonHeight: CGFloat = 64
        static let defaultOffset: CGFloat = 36
        static let friendsButtonCornerRadius: CGFloat = 16
        static let informationStackViewSpacing: CGFloat = 16
        static let defaultAvatarLink: String = "https://s3-alpha-sig.figma.com/img/a92b/ba97/a13937d71ea4ab29b068a92fd325aa74?Expires=1731283200&Key-Pair-Id=APKAQ4GOSFWCVNEHN3O4&Signature=NChlGzcfGZDhcEKxSkCuF2s07eic2KBzFrFDqDNR-cLTSRdLnoGdp3lgKFZJ70jgBCxUWz6J7LE~nBKRbeBagiPAx6PEpRfiaTPv5B5YMnrjkP3m9OshStQuDb7LJyufIqH1swKkFOywX7Wo3uEwUtueMagv6J~UzRAPWoxqvgJaRbi2uET-TmmLY4bCcB8tqfvPaCrjKm0ajPGWlpP7TzTfEuZbulvT2MgKpg5taY4z-iXg6Mrww8Xge05ioMU5V4raAnRNpOgFyRGbq3ZZkT1LsKjQ4HLyLWxycmaukA1zWwLcm7OfsDlOx~OB3Uwkl04nTnIxe8NfaOEwQSb1FQ__"
    }
}
