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
    
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    
    private let backgroundImageView = UIImageView()
    
    private let profileInformationContainer = UIView()
    private let profileImageView = UIImageView()
    private let timeLabel = UILabel()
    private let nameLabel = UILabel()
    private let logoutButton = UIButton()
    
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
        
        setupScrollView()
        setupContentView()
    }
}

private extension ProfileViewController {
    
    func setup() {
        setupScrollView()
        setupContentView()
        setupView()
    }
    
    func setupScrollView() {
        view.addSubview(scrollView)
        scrollView.snp.makeConstraints { make in
            make.top.bottom.leading.trailing.equalToSuperview()
        }
    }

    func setupContentView() {
        scrollView.addSubview(contentView)
        contentView.snp.makeConstraints { make in
            make.top.bottom.leading.trailing.equalToSuperview()
            make.width.equalTo(scrollView)
        }
        
        setupContent()
    }
    
    func setupView() {
        view.backgroundColor = .background
    }

    func setupContent() {
        configureBackgroundImageView()
        configureProfileInformationContainer()
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
            make.height.equalTo(96)
        }
    }
    
    func configureProfileImageView() {
        if let profileImageURL = URL(string: self.viewModel.userData.profileImageURL) {
            self.profileImageView.kf.setImage(with: profileImageURL)
        }
    }
}

// MARK: - Constants
private extension ProfileViewController {
    enum Constants {
        static let backgroundImageCornerRadius: CGFloat = 32
        static let horizontalInset: CGFloat = 24
    }
}
