//
//  WelcomeViewController.swift
//  MovieCatalogApp
//
//  Created by Богдан Тарченко on 11.10.2024.
//

import UIKit
import SnapKit

final class WelcomeViewController: UIViewController {
    
    private var viewModel: WelcomeViewModel
    
    private let background = UIImageView()
    private let titleLabel = UILabel()
    private let signInButton = CustomButton(style: .gradient)
    private let signUpButton = CustomButton(style: .plain)
    
    init(viewModel: WelcomeViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
}

// MARK: - Setup
private extension WelcomeViewController {
    func setup() {
        setupView()
        configureUI()
    }
    
    func setupView() {
        view.backgroundColor = .background
        self.background.image = UIImage(named: Constants.backgroundImageName)
        self.background.contentMode = .scaleAspectFill
        
        self.view.addSubview(self.background)
        
        self.background.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    func configureUI() {
        configureTitleLabel()
        configureButtons()
    }
    
    func configureTitleLabel() {
        titleLabel.text = LocalizedString.Welcome.welcomeMessage
        titleLabel.font = UIFont(name: Constants.titleFontName, size: Constants.titleFontSize)
        titleLabel.numberOfLines = 2
        titleLabel.textColor = .textDefault
        
        view.addSubview(titleLabel)
        
        titleLabel.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(Constants.horizontalEdgesConstraintsValue)
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
        }
    }
    
    func configureButtons() {
        let stackView = UIStackView(arrangedSubviews: [signInButton, signUpButton])
        stackView.axis = .vertical
        stackView.spacing = 8
        stackView.alignment = .fill
        
        view.addSubview(stackView)
        
        stackView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(Constants.horizontalEdgesConstraintsValue)
            make.bottom.equalTo(view.safeAreaLayoutGuide).inset(Constants.bottomEdgeConstraintValue)
        }
        
        configureSignInButton()
        configureSignUpButton()
    }
    
    func configureSignInButton() {
        signInButton.setTitle(LocalizedString.Welcome.signInButtonTitle, for: .normal)
        signInButton.addTarget(self, action: #selector(signInButtonTapped), for: .touchUpInside)
    }
    
    func configureSignUpButton() {
        signUpButton.setTitle(LocalizedString.Welcome.signUpButtonTitle, for: .normal)
        signUpButton.addTarget(self, action: #selector(signUpButtonTapped), for: .touchUpInside)
    }
    
    // MARK: - Actions
    @objc func signInButtonTapped() {
        viewModel.signInButtonTapped()
    }
    
    @objc func signUpButtonTapped() {
        viewModel.signUpButtonTapped()
    }
}

// MARK: - Constants
private extension WelcomeViewController {
    enum Constants {
        static let horizontalEdgesConstraintsValue: CGFloat = 24
        static let bottomEdgeConstraintValue: CGFloat = 24
        static let titleFontName = "Manrope-Bold"
        static let titleFontSize: CGFloat = 36
        static let backgroundImageName = "welcome_background"
    }
}
