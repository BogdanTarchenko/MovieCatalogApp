//
//  SignUpViewController.swift
//  MovieCatalogApp
//
//  Created by Богдан Тарченко on 11.10.2024.
//

import UIKit

class SignUpViewController: UIViewController, UITextFieldDelegate {
    
    private var viewModel: SignUpViewModel
    
    private let background = UIImageView()
    private let loginTextField = CustomTextField(placeholder: "Логин", style: .information)
    private let emailTextField = CustomTextField(placeholder: "Электронная почта", style: .information)
    private let nameTextField = CustomTextField(placeholder: "Имя", style: .information)
    private let passwordTextField = CustomTextField(placeholder: "Пароль", style: .password)
    private let repeatPasswordTextField = CustomTextField(placeholder: "Повторите пароль", style: .password)
    private let dateOfBirthTextField = CustomTextField(placeholder: "Дата рождения", style: .date)
    private let genderButton = SplitButton(leftTitle: "Мужчина", rightTitle: "Женщина")
    
    private let signInButton = CustomButton(style: .inactive)
    
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
            self?.signInButton.toggleStyle(isActive ? .gradient : .inactive)
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
        
        background.image = UIImage(named: "sign_up_background")
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
        let stackView = UIStackView(arrangedSubviews: [
            loginTextField,
            emailTextField,
            nameTextField,
            passwordTextField,
            repeatPasswordTextField,
            dateOfBirthTextField,
            genderButton
        ])
        
        stackView.axis = .vertical
        stackView.spacing = 8
        stackView.alignment = .fill
        
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
    
    @objc func emailTextFieldChanged() {
        viewModel.updateEmail(emailTextField.text)
    }
    
    @objc func nameTextFieldChanged() {
        viewModel.updateName(nameTextField.text)
    }
    
    @objc func passwordTextFieldChanged() {
        viewModel.updatePassword(passwordTextField.text)
    }
    
    @objc func repeatPasswordTextFieldChanged() {
        viewModel.updateRepeatedPassword(repeatPasswordTextField.text)
    }
    
    @objc func dateOfBirthTextFieldChanged() {
        if let datePicker = dateOfBirthTextField.inputView as? UIDatePicker {
            let selectedDate = datePicker.date
            viewModel.updateDateOfBirth(selectedDate)
        }
    }
}
