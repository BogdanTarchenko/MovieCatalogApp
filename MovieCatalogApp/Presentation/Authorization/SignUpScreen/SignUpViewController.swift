//
//  SignUpViewController.swift
//  MovieCatalogApp
//
//  Created by Богдан Тарченко on 11.10.2024.
//

import UIKit

final class SignUpViewController: UIViewController, UITextFieldDelegate, UIScrollViewDelegate {
    
    private var viewModel: SignUpViewModel
    
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    
    
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
    
    private let loaderView = LoaderView()
    
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
        bindToViewModel()
    }
}

// MARK: - Setup
private extension SignUpViewController {
    func setup() {
        setupScrollView()
        setupContentView()
        setupView()
        addTapGestureToDismissKeyboard()
    }
    
    private func setupScrollView() {
        self.scrollView.delegate = self
        view.addSubview(scrollView)
        scrollView.contentInsetAdjustmentBehavior = .never
        scrollView.backgroundColor = .clear
        scrollView.snp.makeConstraints { make in
            make.leading.trailing.top.equalToSuperview()
            make.bottom.equalTo(view.keyboardLayoutGuide.snp.top).offset(-24)
        }
    }
    
    private func setupContentView() {
        scrollView.addSubview(contentView)
        contentView.snp.makeConstraints { make in
            make.top.bottom.leading.trailing.equalToSuperview()
            make.width.equalToSuperview()
        }
        configureUI()
    }
    
    func setupView() {
        view.backgroundColor = .background
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
    }
    
    func configureUI() {
        configureStackView()
        configureBackgroundImageView()
        setupLoaderView()
    }
    
    func addTapGestureToDismissKeyboard() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tapGesture)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    func setupLoaderView() {
        loaderView.isHidden = true
        
        view.addSubview(loaderView)
        view.bringSubviewToFront(loaderView)
        
        loaderView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.size.equalTo(100)
        }
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
        stackView.spacing = Constants.stackViewSpacing
        stackView.setCustomSpacing(Constants.stackViewCustomSpacing, after: genderButton)
        
        configureTextFields()
        configureButton()
        
        contentView.addSubview(stackView)
        
        stackView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(Constants.stackViewInset)
            make.bottom.equalToSuperview().inset(Constants.stackViewBottomInset)
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
    
    func updateTextFieldValidation() {
        loginTextField.layer.borderColor = viewModel.isUsernameValid ? UIColor.clear.cgColor : UIColor.accent.cgColor
        loginTextField.layer.borderWidth = viewModel.isUsernameValid ? 0 : 1
        
        emailTextField.layer.borderColor = viewModel.isEmailValid ? UIColor.clear.cgColor : UIColor.accent.cgColor
        emailTextField.layer.borderWidth = viewModel.isEmailValid ? 0 : 1
        
        passwordTextField.layer.borderColor = viewModel.isPasswordValid ? UIColor.clear.cgColor : UIColor.accent.cgColor
        passwordTextField.layer.borderWidth = viewModel.isPasswordValid ? 0 : 1
        
        repeatPasswordTextField.layer.borderColor = viewModel.isRepeatedPasswordValid ? UIColor.clear.cgColor : UIColor.accent.cgColor
        repeatPasswordTextField.layer.borderWidth = viewModel.isRepeatedPasswordValid ? 0 : 1
        
        nameTextField.layer.borderColor = viewModel.isNameValid ? UIColor.clear.cgColor : UIColor.accent.cgColor
        nameTextField.layer.borderWidth = viewModel.isNameValid ? 0 : 1
    }
    
    func configureButton() {
        signUpButton.setTitle(LocalizedString.SignUp.signUpButtonTitle, for: .normal)
        signUpButton.addTarget(self, action: #selector(signUpButtonTapped), for: .touchUpInside)
    }
    
    func configureBackgroundImageView() {
        backgroundImageView.image = UIImage(named: Constants.backgroundImageName)
        backgroundImageView.contentMode = .scaleAspectFill
        backgroundImageView.clipsToBounds = true
        backgroundImageView.layer.cornerRadius = Constants.backgroundImageCornerRadius
        backgroundImageView.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        backgroundImageView.layer.masksToBounds = true
        
        contentView.addSubview(backgroundImageView)
        
        backgroundImageView.snp.makeConstraints { make in
            make.bottom.equalTo(stackView.snp.top).offset(Constants.backgroundImageBottomOffset)
            make.top.leading.trailing.equalToSuperview()
        }
    }
    
    // MARK: - Actions
    @objc func signUpButtonTapped() {
        Task {
            await viewModel.signUpButtonTapped()
        }
    }
    
    @objc func loginTextFieldChanged() {
        loginTextField.toggleIcons()
        viewModel.updateUsername(loginTextField.text ?? SC.empty)
        updateTextFieldValidation()
    }
    
    @objc func emailTextFieldChanged() {
        emailTextField.toggleIcons()
        viewModel.updateEmail(emailTextField.text ?? SC.empty)
        updateTextFieldValidation()
    }
    
    @objc func nameTextFieldChanged() {
        nameTextField.toggleIcons()
        viewModel.updateName(nameTextField.text ?? SC.empty)
        updateTextFieldValidation()
    }
    
    @objc func passwordTextFieldChanged() {
        passwordTextField.toggleIcons()
        viewModel.updatePassword(passwordTextField.text ?? SC.empty)
        updateTextFieldValidation()
    }
    
    @objc func repeatPasswordTextFieldChanged() {
        repeatPasswordTextField.toggleIcons()
        viewModel.updateRepeatedPassword(repeatPasswordTextField.text ?? SC.empty)
        updateTextFieldValidation()
    }
    
    @objc func dateOfBirthTextFieldChanged() {
        if let datePicker = dateOfBirthTextField.inputView as? UIDatePicker {
            let selectedDate = datePicker.date
            dateOfBirthTextField.toggleIcons()
            viewModel.updateDateOfBirth(selectedDate)
        }
    }
    
    // MARK: - Bindings
    private func bindToViewModel() {
        viewModel.isSignUpButtonActive = { [weak self] isActive in
            self?.signUpButton.toggleStyle(isActive ? .gradient : .inactive)
        }
        
        viewModel.isLoading = { [weak self] isLoading in
            isLoading ? self?.showLoader() : self?.hideLoader()
        }
    }
    
    // MARK: - Loader
    private func showLoader() {
        DispatchQueue.main.async {
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
    }
    
    private func hideLoader() {
        DispatchQueue.main.async {
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
}

// MARK: - Constants
private extension SignUpViewController {
    enum Constants {
        static let stackViewSpacing: CGFloat = 8
        static let stackViewCustomSpacing: CGFloat = 32
        static let stackViewInset: CGFloat = 24
        static let stackViewBottomInset: CGFloat = 24
        static let backgroundImageBottomOffset: CGFloat = -16
        static let backgroundImageCornerRadius: CGFloat = 32
        static let backgroundImageName = "sign_up_background"
    }
}
