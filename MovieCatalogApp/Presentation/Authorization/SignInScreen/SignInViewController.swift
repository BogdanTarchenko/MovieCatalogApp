//
//  SignInViewController.swift
//  MovieCatalogApp
//
//  Created by Богдан Тарченко on 11.10.2024.
//

import UIKit

final class SignInViewController: UIViewController, UITextFieldDelegate {
    
    private var viewModel: SignInViewModel
    private var loadingViewController: LoadingViewController?
    
    private let backgroundImageView = UIImageView()
    private let stackView = UIStackView()
    
    private let signInButton = CustomButton(style: .inactive)
    private let loginTextField = CustomTextField(style: .information(.username))
    private let passwordTextField = CustomTextField(style: .password(.password))
    
    init(viewModel: SignInViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        viewModel.isSignInButtonActive = { [weak self] isActive in
            self?.signInButton.toggleStyle(isActive ? .gradient : .inactive)
        }
    }
}
// MARK: - Setup
private extension SignInViewController {
    func setup() {
        setupView()
        configureUI()
        addTapGestureToDismissKeyboard()
    }
    
    func setupView() {
        view.backgroundColor = .background
    }
    
    func configureUI() {
        configureStackView()
        configureBackgroundImageView()
    }
    
    func addTapGestureToDismissKeyboard() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tapGesture)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    func configureStackView() {
        stackView.addArrangedSubview(loginTextField)
        stackView.addArrangedSubview(passwordTextField)
        stackView.addArrangedSubview(signInButton)
        
        stackView.axis = .vertical
        stackView.spacing = Constants.stackViewSpacing
        stackView.setCustomSpacing(Constants.stackViewCustomSpacing, after: passwordTextField)
        
        configureTextFields()
        configureButton()
        
        view.addSubview(stackView)
        
        stackView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(Constants.horizontalEdgesConstraintsValue)
            make.bottom.equalTo(view.safeAreaLayoutGuide).inset(Constants.bottomEdgeConstraintValue)
        }
    }
    
    func configureTextFields() {
        loginTextField.delegate = self
        passwordTextField.delegate = self
        
        loginTextField.addTarget(self, action: #selector(loginTextFieldChanged), for: .editingChanged)
        passwordTextField.addTarget(self, action: #selector(passwordTextFieldChanged), for: .editingChanged)
    }
    
    func configureButton() {
        signInButton.setTitle(LocalizedString.SignIn.signInButtonTitle, for: .normal)
        signInButton.addTarget(self, action: #selector(signInButtonTapped), for: .touchUpInside)
    }
    
    func configureBackgroundImageView() {
        backgroundImageView.image = UIImage(named: Constants.backgroundImageName)
        backgroundImageView.contentMode = .scaleAspectFill
        backgroundImageView.clipsToBounds = true
        backgroundImageView.layer.cornerRadius = Constants.backgroundCornerRadius
        backgroundImageView.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        backgroundImageView.layer.masksToBounds = true
        
        view.addSubview(backgroundImageView)
        
        backgroundImageView.snp.makeConstraints { make in
            make.bottom.equalTo(stackView.snp.top).offset(Constants.backgroundBottomOffset)
            make.top.leading.trailing.equalToSuperview()
        }
    }
    
    // MARK: - Actions
    @objc func signInButtonTapped() {
        showLoadingScreen()
        Task {
            await viewModel.signInButtonTapped()
            hideLoadingScreen()
        }
    }
    
    @objc func loginTextFieldChanged() {
        loginTextField.toggleIcons()
        viewModel.updateUsername(loginTextField.text ?? SC.empty)
    }
    
    @objc func passwordTextFieldChanged() {
        passwordTextField.toggleIcons()
        viewModel.updatePassword(passwordTextField.text ?? SC.empty)
    }
}

// MARK: - Constants
private extension SignInViewController {
    enum Constants {
        static let horizontalEdgesConstraintsValue: CGFloat = 24
        static let bottomEdgeConstraintValue: CGFloat = 24
        static let stackViewSpacing: CGFloat = 8
        static let stackViewCustomSpacing: CGFloat = 32
        static let backgroundCornerRadius: CGFloat = 32
        static let backgroundBottomOffset: CGFloat = -16
        static let backgroundImageName = "sign_in_background"
    }
}
