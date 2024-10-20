//
//  WelcomeViewController.swift
//  MovieCatalogApp
//
//  Created by Богдан Тарченко on 11.10.2024.
//

import UIKit
import SnapKit

class WelcomeViewController: UIViewController {
    
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

private extension WelcomeViewController {
    func setup() {
        setupView()
        configureUI()
    }
    
    func setupView() {
        self.view.backgroundColor = .background
        
        background.image = UIImage(named: "welcome_background")
        background.contentMode = .scaleAspectFill
        
        view.addSubview(background)
        
        background.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    func configureUI() {
        configureTitleLabel()
        configureButtons()
    }
    
    func configureTitleLabel() {
        titleLabel.text = NSLocalizedString("welcome_title", comment: "")
        titleLabel.font = UIFont(name: "Manrope-Bold", size: 36)
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
        signInButton.setTitle(NSLocalizedString("welcome_sign_in_button_title", comment: ""), for: .normal)
        signInButton.addTarget(self, action: #selector(signInButtonTapped), for: .touchUpInside)
    }
    
    func configureSignUpButton() {
        signUpButton.setTitle(NSLocalizedString("welcome_sign_up_button_title", comment: ""), for: .normal)
        signUpButton.addTarget(self, action: #selector(signUpButtonTapped), for: .touchUpInside)
    }
    
    // MARK: - Button Actions
    @objc func signInButtonTapped() {
        viewModel.signInButtonTapped()
    }
    
    @objc func signUpButtonTapped() {
        viewModel.signUpButtonTapped()
    }
}

// MARK: - WelcomeViewController.Constants
private extension WelcomeViewController {
    enum Constants {
        static let horizontalEdgesConstraintsValue: CGFloat = 24
        static let bottomEdgeConstraintValue: CGFloat = 24
    }
}
