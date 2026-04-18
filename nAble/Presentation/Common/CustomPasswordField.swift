import UIKit

class CustomPasswordField: UIView {
    //MARK: Properties
       var placeholderString: String
       private var isPasswordVisible = false
       
       var label: UILabel = {
           var label = UILabel()
           label.textColor = UIColor(named: "AppGray")
           label.font = UIFont(name: "FiraGO-Regular", size: 14)
           label.translatesAutoresizingMaskIntoConstraints = false
           
           return label
       }()
       
       var textField: UITextField = {
           var textField = UITextField()
           textField.font = UIFont(name: "FiraGO-Regular", size: 14)
           textField.textColor = UIColor(named: "AppGray")
           textField.layer.cornerRadius = 8
           textField.layer.borderWidth = 1.5
           textField.layer.borderColor = UIColor(named: "AppGray")?.cgColor
           textField.isSecureTextEntry = true
           textField.translatesAutoresizingMaskIntoConstraints = false
           textField.isUserInteractionEnabled = true
           
           return textField
       }()
       
       private lazy var lockIcon: UIImageView = {
           let imageView = UIImageView()
           imageView.image = UIImage(named: "lockIcon")
           imageView.contentMode = .scaleAspectFit
           imageView.tintColor = UIColor(named: "AppGray")
           imageView.translatesAutoresizingMaskIntoConstraints = false
           return imageView
       }()
       
       private lazy var toggleButton: UIButton = {
           let button = UIButton(type: .custom)
           button.setImage(UIImage(systemName: "eye.slash"), for: .normal)
           button.tintColor = UIColor(named: "AppGray")
           button.addTarget(self, action: #selector(togglePasswordVisibility), for: .touchUpInside)
           button.translatesAutoresizingMaskIntoConstraints = false
           return button
       }()
       
       private lazy var errorLabel: UILabel = {
           let label = UILabel()
           label.textColor = UIColor(named: "AppRed")
           label.font = UIFont(name: "FiraGO-Regular", size: 12)
           label.numberOfLines = 0
           label.translatesAutoresizingMaskIntoConstraints = false
           label.isHidden = true
           return label
       }()
       
       //MARK: Inits
       init(placeholderString: String) {
           self.placeholderString = placeholderString
           super.init(frame: .zero)
           setupView()
           configurePlaceholder()
       }
    
       override init(frame: CGRect) {
           self.placeholderString = ""
           super.init(frame: frame)
           setupView()
       }
       
       required init?(coder: NSCoder) {
           fatalError()
       }
       
       //MARK: Methods
       private func configurePlaceholder() {
           let attributes: [NSAttributedString.Key: Any] = [
               .font: UIFont(name: "FiraGO-Regular", size: 14)!,
               .foregroundColor: UIColor(named: "AppGray")!
           ]
           textField.attributedPlaceholder = NSAttributedString(string: placeholderString, attributes: attributes)
       }
       
       private func setupView() {
           addSubview(label)
           addSubview(textField)
           addSubview(lockIcon)
           addSubview(toggleButton)
           addSubview(errorLabel)
               
           NSLayoutConstraint.activate([
               label.topAnchor.constraint(equalTo: topAnchor),
               label.leadingAnchor.constraint(equalTo: leadingAnchor),
               label.trailingAnchor.constraint(equalTo: trailingAnchor),
                   
               textField.topAnchor.constraint(equalTo: label.bottomAnchor, constant: 5),
               textField.leadingAnchor.constraint(equalTo: leadingAnchor),
               textField.trailingAnchor.constraint(equalTo: trailingAnchor),
               textField.heightAnchor.constraint(equalToConstant: 45),
               
               lockIcon.leadingAnchor.constraint(equalTo: textField.leadingAnchor, constant: 11),
               lockIcon.centerYAnchor.constraint(equalTo: textField.centerYAnchor),
               lockIcon.widthAnchor.constraint(equalToConstant: 15),
               lockIcon.heightAnchor.constraint(equalToConstant: 18),
               
               toggleButton.trailingAnchor.constraint(equalTo: textField.trailingAnchor, constant: -11),
               toggleButton.centerYAnchor.constraint(equalTo: textField.centerYAnchor),
               toggleButton.widthAnchor.constraint(equalToConstant: 25),
               toggleButton.heightAnchor.constraint(equalToConstant: 25),
               
               errorLabel.topAnchor.constraint(equalTo: textField.bottomAnchor, constant: 4),
               errorLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
               errorLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
               errorLabel.bottomAnchor.constraint(equalTo: bottomAnchor)
           ])
           
           textField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 35, height: 45))
           textField.leftViewMode = .always
           textField.rightView = UIView(frame: CGRect(x: 0, y: 0, width: 45, height: 45))
           textField.rightViewMode = .always
           
           registerForTraitChanges([UITraitUserInterfaceStyle.self]) { (self: Self, previousTraitCollection) in
               self.textField.layer.borderColor = UIColor(named: "AppGray")?.cgColor
           }
       }
    
    func showError(_ message: String?) {
        if let message = message {
            errorLabel.text = message
            errorLabel.isHidden = false
        } else {
            errorLabel.text = nil
            errorLabel.isHidden = true
            textField.layer.borderColor = UIColor(named: "AppGray")?.cgColor
        }
    }
    
    @objc private func togglePasswordVisibility() {
        isPasswordVisible.toggle()
        textField.isSecureTextEntry = !isPasswordVisible
        
        let imageName = isPasswordVisible ? "eye" : "eye.slash"
        toggleButton.setImage(UIImage(systemName: imageName), for: .normal)
    }
}
