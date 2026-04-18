import UIKit

class CustomTextField: UIView {
    var placeholderString: String
    
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
           
           textField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 11, height: 0))
           textField.leftViewMode = .always
           textField.rightView = UIView(frame: CGRect(x: 0, y: 0, width: 11, height: 0))
           textField.rightViewMode = .always
           textField.translatesAutoresizingMaskIntoConstraints = false
           
           return textField
       }()
       
       private var errorLabel: UILabel = {
           var label = UILabel()
           label.textColor = UIColor(named: "AppRed")
           label.font = UIFont(name: "FiraGO-Regular", size: 12)
           label.numberOfLines = 0
           label.translatesAutoresizingMaskIntoConstraints = false
           label.isHidden = true
           
           return label
       }()
    
    init(placeholderString: String) {
        self.placeholderString = placeholderString
        super.init(frame: .zero)
        setupView()
        configurePlaceholder()
    }
    
    override init(frame: CGRect) {
        self.placeholderString = ""
        super.init(frame: frame)
    }
    
    required init(coder: NSCoder) {
        fatalError()
    }
    
    private var errorLabelHeightConstraint: NSLayoutConstraint?
    
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
        addSubview(errorLabel)
        
        errorLabelHeightConstraint = errorLabel.heightAnchor.constraint(equalToConstant: 0)
        errorLabelHeightConstraint?.isActive = true
            
        NSLayoutConstraint.activate([
            label.topAnchor.constraint(equalTo: topAnchor),
            label.leadingAnchor.constraint(equalTo: leadingAnchor),
            label.trailingAnchor.constraint(equalTo: trailingAnchor),
                
            textField.topAnchor.constraint(equalTo: label.bottomAnchor, constant: 5),
            textField.leadingAnchor.constraint(equalTo: leadingAnchor),
            textField.trailingAnchor.constraint(equalTo: trailingAnchor),
            textField.heightAnchor.constraint(equalToConstant: 45),
            
            errorLabel.topAnchor.constraint(equalTo: textField.bottomAnchor, constant: 4),
            errorLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            errorLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
            errorLabel.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
            
        registerForTraitChanges([UITraitUserInterfaceStyle.self]) { (self: Self, previousTraitCollection) in
            self.textField.layer.borderColor = UIColor(named: "AppGray")?.cgColor
        }
    }
    
    func showError(_ message: String?) {
        if let message = message {
            errorLabel.text = message
            errorLabel.isHidden = false
            errorLabelHeightConstraint?.isActive = false
        } else {
            errorLabel.text = nil
            errorLabel.isHidden = true
            errorLabelHeightConstraint?.isActive = true
            textField.layer.borderColor = UIColor(named: "AppRed")?.cgColor
        }
    }
}
