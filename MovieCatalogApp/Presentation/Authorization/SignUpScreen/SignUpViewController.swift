//
//  SignUpViewController.swift
//  MovieCatalogApp
//
//  Created by Богдан Тарченко on 11.10.2024.
//

import UIKit

class SignUpViewController: UIViewController, UITextFieldDelegate {
    
    private var viewModel: SignUpViewModel
    
    private let backgroundImageView = UIImageView()
    private let stackView = UIStackView()
    
    private let loginTextField = CustomTextField(style: .information(.username))
    private let emailTextField = CustomTextField(style: .information(.email))
    private let nameTextField = CustomTextField(style: .information(.name))
    private let passwordTextField = CustomTextField(style: .password(.password))
    private let repeatPasswordTextField = CustomTextField(style: .password(.repeatedPassword))
    private let dateOfBirthTextField = CustomTextField(style: .date(.dateOfBirth))
    private let genderButton = SplitButton(style: .genderPicker)
    
    private let signUpButton = CustomButton(style: .inactive)
    
    init(viewModel: SignUpViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        
        viewModel.isSignUpButtonActive = { [weak self] isActive in
            self?.signUpButton.toggleStyle(isActive ? .gradient : .inactive)
        }
    }
}

private extension SignUpViewController {
    func setup() {
        setupView()
        configureUI()
    }
    
    func setupView() {
        view.backgroundColor = .background
    }
    
    func configureUI() {
        configureStackView()
        configureBackgroundImageView()
    }
    
    func configureStackView() {
        stackView.addArrangedSubview(loginTextField)
        stackView.addArrangedSubview(emailTextField)
        stackView.addArrangedSubview(nameTextField)
        stackView.addArrangedSubview(passwordTextField)
        stackView.addArrangedSubview(repeatPasswordTextField)
        stackView.addArrangedSubview(dateOfBirthTextField)
        stackView.addArrangedSubview(genderButton)
        stackView.addArrangedSubview(signUpButton)
        
        stackView.axis = .vertical
        stackView.spacing = 8
        stackView.setCustomSpacing(32, after: genderButton)
        
        configureTextFields()
        configureButton()
        
        view.addSubview(stackView)
        
        stackView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(24)
            make.bottom.equalTo(view.safeAreaLayoutGuide).inset(24)
        }
        
        genderButton.onGenderSelected = { [weak self] gender in
            self?.viewModel.updateGender(gender)
        }
    }
    
    func configureTextFields() {
        loginTextField.delegate = self
        emailTextField.delegate = self
        nameTextField.delegate = self
        passwordTextField.delegate = self
        repeatPasswordTextField.delegate = self
        dateOfBirthTextField.delegate = self
        
        loginTextField.addTarget(self, action: #selector(loginTextFieldChanged), for: .editingChanged)
        emailTextField.addTarget(self, action: #selector(emailTextFieldChanged), for: .editingChanged)
        nameTextField.addTarget(self, action: #selector(nameTextFieldChanged), for: .editingChanged)
        passwordTextField.addTarget(self, action: #selector(passwordTextFieldChanged), for: .editingChanged)
        repeatPasswordTextField.addTarget(self, action: #selector(repeatPasswordTextFieldChanged), for: .editingChanged)
        dateOfBirthTextField.addTarget(self, action: #selector(dateOfBirthTextFieldChanged), for: .editingDidEnd)
    }
    
    func configureButton() {
        signUpButton.setTitle(NSLocalizedString("sign_up_button_title", comment: ""), for: .normal)
        signUpButton.addTarget(self, action: #selector(signUpButtonTapped), for: .touchUpInside)
    }
    
    func configureBackgroundImageView() {
        backgroundImageView.image = UIImage(named: "sign_up_background")
        backgroundImageView.contentMode = .scaleAspectFill
        backgroundImageView.clipsToBounds = true
        backgroundImageView.layer.cornerRadius = 32
        backgroundImageView.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        backgroundImageView.layer.masksToBounds = true
        
        view.addSubview(backgroundImageView)
        
        backgroundImageView.snp.makeConstraints { make in
            make.bottom.equalTo(stackView.snp.top).offset(-16)
            make.top.leading.trailing.equalToSuperview()
        }
    }
    
    @objc func signUpButtonTapped() {
        Task {
            await viewModel.signUpButtonTapped()
        }
    }
    
    @objc func loginTextFieldChanged() {
        loginTextField.toggleIcons()
        viewModel.updateUsername(loginTextField.text ?? SC.empty)
    }
    
    @objc func emailTextFieldChanged() {
        emailTextField.toggleIcons()
        viewModel.updateEmail(emailTextField.text ?? SC.empty)
    }
    
    @objc func nameTextFieldChanged() {
        nameTextField.toggleIcons()
        viewModel.updateName(nameTextField.text ?? SC.empty)
    }
    
    @objc func passwordTextFieldChanged() {
        passwordTextField.toggleIcons()
        viewModel.updatePassword(passwordTextField.text ?? SC.empty)
    }
    
    @objc func repeatPasswordTextFieldChanged() {
        repeatPasswordTextField.toggleIcons()
        viewModel.updateRepeatedPassword(repeatPasswordTextField.text ?? SC.empty)
    }
    
    @objc func dateOfBirthTextFieldChanged() {
        
        if let datePicker = dateOfBirthTextField.inputView as? UIDatePicker {
            let selectedDate = datePicker.date
            dateOfBirthTextField.toggleIcons()
            viewModel.updateDateOfBirth(selectedDate)
        }
    }
}
