import UIKit

class LogInViewController: UIViewController {
    var viewmodel: LoginViewModel
    weak var coordinator: AuthCoordinator?
    
    private let logoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "logo")
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        return imageView
    }()
    
    private let emailField: CustomTextField = {
          let field = CustomTextField(placeholderString: "Your email address")
          field.label.text = "Email"
          field.textField.keyboardType = .emailAddress
          field.textField.autocapitalizationType = .none
          field.translatesAutoresizingMaskIntoConstraints = false
          
          return field
      }()
      
      private let passwordField: CustomPasswordField = {
          let field = CustomPasswordField(placeholderString: "Your password")
          field.label.text = "Password"
          field.translatesAutoresizingMaskIntoConstraints = false
          
          return field
      }()
    
    private let loginButton: CustomButton = {
        let button = CustomButton(
        title: "Log In",
        backgroundColor: UIColor(named: "AppGreen"),
        cornerRadius: 8
        )
           
        return button
    }()
    
    private let skipButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Skip", for: .normal)
        button.titleLabel?.font = UIFont(name: "FiraGO-Medium", size: 16)
        button.setTitleColor(UIColor(named: "AppBlack"), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
           
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(named: "AppBG")
        setupUI()
    }
    
    init(viewmodel: LoginViewModel) {
        self.viewmodel = viewmodel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    private func setupUI() {
        view.addSubview(logoImageView)
        view.addSubview(emailField)
        view.addSubview(passwordField)
        view.addSubview(loginButton)
        view.addSubview(skipButton)
        
        NSLayoutConstraint.activate(
            [
                logoImageView.topAnchor.constraint(equalTo: view.topAnchor, constant: 50),
                logoImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                logoImageView.widthAnchor.constraint(equalToConstant: 150),
                logoImageView.heightAnchor.constraint(equalToConstant: 150),
                
                emailField.topAnchor.constraint(equalTo: logoImageView.bottomAnchor, constant: 40),
                emailField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
                emailField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40),
                
                passwordField.topAnchor.constraint(equalTo: emailField.bottomAnchor, constant: 40),
                passwordField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
                passwordField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40),
                
                loginButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -80),
                loginButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
                loginButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40),
                loginButton.heightAnchor.constraint(equalToConstant: 50),

                skipButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 70),
                skipButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
            ]
        )
    }
}
