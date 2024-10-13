//
//  SignInViewController.swift
//  MovieCatalogApp
//
//  Created by Богдан Тарченко on 11.10.2024.
//

import UIKit

class SignInViewController: UIViewController, UITextFieldDelegate {
    
    private var viewModel: SignInViewModel
    
    private let background = UIImageView()
    private let signInButton = CustomButton(style: .inactive)
    private let loginTextField = CustomTextField(placeholder: "Логин", style: .information)
    private let passwordTextField = CustomTextField(placeholder: "Пароль", style: .password)
    
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

private extension SignInViewController {
    func setup() {
        setupView()
        configureUI()
    }
    
    func setupView() {
        view.backgroundColor = .background
        
        background.image = UIImage(named: "sign_in_background")
        background.contentMode = .scaleAspectFit
        
        view.insertSubview(background, at: 0)
        
        background.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
        }
    }
    
    func configureUI() {
        configureTextFields()
        configureButton()
    }
    
    func configureTextFields() {
        let stackView = UIStackView(arrangedSubviews: [loginTextField, passwordTextField])
        stackView.axis = .vertical
        stackView.spacing = 8
        stackView.alignment = .fill
        
        loginTextField.delegate = self
        passwordTextField.delegate = self
        
        loginTextField.addTarget(self, action: #selector(loginTextFieldChanged), for: .editingChanged)
        passwordTextField.addTarget(self, action: #selector(passwordTextFieldChanged), for: .editingChanged)
        
        view.addSubview(stackView)
        
        stackView.snp.makeConstraints { make in
            make.top.equalTo(background.snp.bottom).offset(16)
            make.leading.trailing.equalToSuperview().inset(24)
        }
    }
    
    func configureButton() {
        view.addSubview(signInButton)
        signInButton.setTitle(NSLocalizedString("sign_in_button_title", comment: ""), for: .normal)
        signInButton.addTarget(self, action: #selector(signInButtonTapped), for: .touchUpInside)
        
        signInButton.snp.makeConstraints { make in
            make.bottom.leading.trailing.equalTo(view.safeAreaLayoutGuide).inset(24)
        }
    }
    
    @objc func signInButtonTapped() {
        
    }
    
    @objc func loginTextFieldChanged() {
        viewModel.updateUsername(loginTextField.text)
    }
    
    @objc func passwordTextFieldChanged() {
        viewModel.updatePassword(passwordTextField.text)
    }
}
