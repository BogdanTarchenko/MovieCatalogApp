//
//  CustomTextField.swift
//  MovieCatalogApp
//
//  Created by Богдан Тарченко on 12.10.2024.
//

import UIKit
import SnapKit

class CustomTextField: UITextField {
    
    enum TextFieldStyle {
        case information
        case password
        case date
        case plain
    }
    
    private var placeholderText: String
    private var textFieldStyle: TextFieldStyle
    private let rightButton = UIButton(type: .custom)
    
    init(placeholder: String, style: TextFieldStyle) {
        self.placeholderText = placeholder
        self.textFieldStyle = style
        super.init(frame: .zero)
        configureTextField()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func rightViewRect(forBounds bounds: CGRect) -> CGRect {
        return CGRect(x: bounds.width - 40,
                      y: (bounds.height - 24) / 2,
                      width: 24,
                      height: 24)
    }
    
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return CGRect(x: bounds.origin.x + 16,
                      y: bounds.origin.y,
                      width: bounds.width - 60,
                      height: bounds.height)
    }
    
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return textRect(forBounds: bounds)
    }
}

private extension CustomTextField {
    func configureTextField() {
        layer.cornerRadius = 8
        backgroundColor = .darkFaded
        
        attributedPlaceholder = NSAttributedString(
            string: placeholderText,
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.grayFaded]
        )
        
        font = UIFont(name: "Manrope-Regular", size: 14)
        textColor = .textDefault
        isUserInteractionEnabled = true
        
        snp.makeConstraints { make in
            make.height.equalTo(48)
        }
        
        if textFieldStyle != .plain {
            configureRightButton()
        }
        
        if textFieldStyle == .date {
            configureForDatePicker()
        }
        
        if textFieldStyle == .password {
            isSecureTextEntry = true
        }
    }
    
    func configureRightButton() {
        rightButton.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        rightButton.contentMode = .scaleAspectFit
        
        switch textFieldStyle {
        case .information:
            rightButton.setImage(UIImage(named: "cross"), for: .normal)
        case .password:
            rightButton.setImage(UIImage(named: "eye_closed"), for: .normal)
        case .date:
            rightButton.setImage(UIImage(named: "calendar"), for: .normal)
        case .plain:
            break
        }
        
        rightView = rightButton
        rightViewMode = .always
    }
    
    @objc func buttonTapped() {
        if textFieldStyle == .date {
            self.becomeFirstResponder()
        } else if textFieldStyle == .password {
            togglePasswordIcon()
        } else if textFieldStyle == .information {
            text = ""
            sendActions(for: .editingChanged)
        }
    }
    
    func togglePasswordIcon() {
        if let currentImage = rightButton.currentImage, currentImage == UIImage(named: "eye_opened") {
            rightButton.setImage(UIImage(named: "eye_closed"), for: .normal)
            isSecureTextEntry = true
        } else {
            rightButton.setImage(UIImage(named: "eye_opened"), for: .normal)
            isSecureTextEntry = false
        }
    }
    
    func configureForDatePicker() {
        configureDatePicker(target: self, selector: #selector(doneButtonPressed))
        isUserInteractionEnabled = true
        self.delegate = self
    }
    
    @objc func doneButtonPressed() {
        if let datePicker = self.inputView as? UIDatePicker {
            setDate(from: datePicker)
        }
        resignFirstResponder()
    }
}

extension CustomTextField: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        return textFieldStyle != .date
    }
}
