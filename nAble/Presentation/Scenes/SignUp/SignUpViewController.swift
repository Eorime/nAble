//
//  LogInView.swift
//  nAble
//
//  Created by Eorime on 17.04.26.
//

import UIKit

class SignUpViewController: UIViewController {
    var viewmodel: SignUpViewModel
    weak var coordinator: AuthCoordinator?
    
    private let backButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: "chevronBlack"), for: .normal)
        button.tintColor = UIColor(named: "AppBlack")
        button.translatesAutoresizingMaskIntoConstraints = false
            
        return button
    }()
        
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Sign Up"
        label.font = UIFont(name: "FiraGO-Medium", size: 20)
        label.textColor = UIColor(named: "AppBlack")
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
            
        return label
    }()
        
    private let fullNameField: CustomTextField = {
        let field = CustomTextField(placeholderString: "Your full name")
        field.label.text = "Full Name"
        field.textField.autocapitalizationType = .words
        field.translatesAutoresizingMaskIntoConstraints = false
            
        return field
    }()
        
    private let usernameField: CustomTextField = {
        let field = CustomTextField(placeholderString: "Your username")
        field.label.text = "Username"
        field.textField.autocapitalizationType = .none
        field.translatesAutoresizingMaskIntoConstraints = false
            
        return field
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
        
    private let confirmPasswordField: CustomPasswordField = {
        let field = CustomPasswordField(placeholderString: "Confirm your password")
        field.label.text = "Confirm Password"
        field.translatesAutoresizingMaskIntoConstraints = false
            
        return field
    }()
        
    private let signUpButton: CustomButton = {
        let button = CustomButton(
            title: "Sign Up",
            backgroundColor: UIColor(named: "AppButtonRed"),
            cornerRadius: 8
        )
        return button
    }()
    
    init(viewmodel: SignUpViewModel) {
        self.viewmodel = viewmodel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(named: "AppBG")
        navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    //MARK: Methods
    private func setupUI() {
        view.addSubview(backButton)
        view.addSubview(titleLabel)
        view.addSubview(fullNameField)
        view.addSubview(usernameField)
        view.addSubview(emailField)
        view.addSubview(passwordField)
        view.addSubview(confirmPasswordField)
        view.addSubview(signUpButton)
          
        NSLayoutConstraint.activate([
            backButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 70),
            backButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            backButton.widthAnchor.constraint(equalToConstant: 30),
            backButton.heightAnchor.constraint(equalToConstant: 30),
            
            titleLabel.centerYAnchor.constraint(equalTo: backButton.centerYAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40),
            
            fullNameField.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 40),
            fullNameField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            fullNameField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40),
            
            usernameField.topAnchor.constraint(equalTo: fullNameField.bottomAnchor, constant: 24),
            usernameField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            usernameField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40),
            
            emailField.topAnchor.constraint(equalTo: usernameField.bottomAnchor, constant: 24),
            emailField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            emailField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40),
            
            passwordField.topAnchor.constraint(equalTo: emailField.bottomAnchor, constant: 24),
            passwordField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            passwordField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40),
            
            confirmPasswordField.topAnchor.constraint(equalTo: passwordField.bottomAnchor, constant: 24),
            confirmPasswordField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            confirmPasswordField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40),
            
            signUpButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -80),
            signUpButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            signUpButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40),
            signUpButton.heightAnchor.constraint(equalToConstant: 50),
          ])
      }
    
    
}
