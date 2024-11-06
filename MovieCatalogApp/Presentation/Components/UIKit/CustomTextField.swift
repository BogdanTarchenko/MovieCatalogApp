import UIKit
import SnapKit

final class CustomTextField: UITextField {
    
    enum PlaceholderText {
        enum Information {
            case username
            case email
            case name
        }
        
        enum Password {
            case password
            case repeatedPassword
        }
        
        enum Date {
            case dateOfBirth
        }
    }
    
    enum TextFieldStyle {
        case information(PlaceholderText.Information)
        case password(PlaceholderText.Password)
        case date(PlaceholderText.Date)
        case plain
    }
    
    private var placeholderText: String = ""
    var textFieldStyle: TextFieldStyle
    private let rightButton = UIButton(type: .custom)
    
    init(style: TextFieldStyle) {
        self.textFieldStyle = style
        super.init(frame: .zero)
        configurePlaceholderText()
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
        
        snp.makeConstraints { make in
            make.height.equalTo(48)
        }
        
        configureRightButton()
        
        switch textFieldStyle {
        case .password:
            isSecureTextEntry = true
        case .date:
            configureDatePicker(target: self, selector: #selector(doneButtonPressed))
        default:
            break
        }
    }
    
    func configureRightButton() {
        rightButton.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        rightButton.contentMode = .scaleAspectFit
        
        switch textFieldStyle {
        case .information:
            rightButton.setImage(UIImage(named: "cross"), for: .normal)
            rightButton.isHidden = true
        case .password:
            rightButton.setImage(UIImage(named: "eye_closed"), for: .normal)
            rightButton.isHidden = true
        case .date:
            rightButton.setImage(UIImage(named: "calendar")?.withRenderingMode(.alwaysTemplate), for: .normal)
            rightButton.tintColor = .grayFaded
        case .plain:
            rightButton.isHidden = true
        }
        
        rightView = rightButton
        rightViewMode = .always
    }
    
    @objc func buttonTapped() {
        switch textFieldStyle {
        case .date:
            self.becomeFirstResponder()
        case .password:
            togglePasswordIcon()
        case .information:
            text = ""
            sendActions(for: .editingChanged)
        case .plain:
            break
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
    
    @objc func doneButtonPressed() {
        if let datePicker = self.inputView as? UIDatePicker {
            setDate(from: datePicker)
        }
        resignFirstResponder()
    }
    
    func configurePlaceholderText() {
        placeholderText = placeholderString(for: textFieldStyle)
    }
    
    func placeholderString(for style: TextFieldStyle) -> String {
        switch style {
        case .information(let info):
            return placeholderString(for: info)
        case .password(let password):
            return placeholderString(for: password)
        case .date(let date):
            return placeholderString(for: date)
        case .plain:
            return ""
        }
    }
    
    func placeholderString(for information: PlaceholderText.Information) -> String {
        switch information {
        case .username:
            return LocalizedString.TextField.username
        case .email:
            return LocalizedString.TextField.email
        case .name:
            return LocalizedString.TextField.name
        }
    }
    
    func placeholderString(for password: PlaceholderText.Password) -> String {
        switch password {
        case .password:
            return LocalizedString.TextField.password
        case .repeatedPassword:
            return LocalizedString.TextField.repeatedPassword
        }
    }
    
    func placeholderString(for date: PlaceholderText.Date) -> String {
        switch date {
        case .dateOfBirth:
            return LocalizedString.TextField.dateOfBirth
        }
    }
}

extension CustomTextField {
    func toggleIcons() {
        let hasText = (text != nil && text != "")
        
        switch textFieldStyle {
        case .information:
            rightButton.isHidden = !hasText
            rightButton.tintColor = hasText ? .textDefault : .grayFaded
            
        case .password:
            rightButton.isHidden = !hasText
            rightButton.tintColor = hasText ? .textDefault : .grayFaded
            
        case .date:
            rightButton.isHidden = false
            rightButton.tintColor = hasText ? .textDefault : .grayFaded
            
        case .plain:
            rightButton.isHidden = true
        }
        
        rightView = rightButton
    }
}

extension CustomTextField: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        switch textFieldStyle {
        case .date:
            return false
        case .information, .password, .plain:
            return true
        }
    }
}
