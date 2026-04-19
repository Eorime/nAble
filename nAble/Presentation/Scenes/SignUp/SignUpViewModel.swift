import UIKit

class SignUpViewModel {
    //MARK: Properties
    private let signUpUseCase: SignUpUseCase
    
    var onSignUpSuccess: (() -> Void)?
    var onSignUpError: ((String)-> Void)?
    
    //MARK: Inits
    init(authRepository: AuthRepository) {
        self.signUpUseCase = SignUpUseCase(authRepo: authRepository)
    }
    
    //MARK: Methods
    func validatePassword(_ password: String) -> String? {
        guard password.count >= 6 else {
            return("Password should be at least 6 characters")
        }
        
        guard password.rangeOfCharacter(from: .uppercaseLetters) != nil else {
            return "Password must contain at least one uppercase letter"
        }
        
        guard password.rangeOfCharacter(from: .decimalDigits) != nil else {
            return "Password must contain at least one number"
        }
        
        return nil
    }
    
    func signUp(email: String, password: String, fullName: String, username: String) {
        if let validationError = validatePassword(password) {
            onSignUpError?(validationError)
            return
        }
        
        LoaderManager.shared.show()
        signUpUseCase.execute(email: email, password: password, fullName: fullName, userName: username) { [weak self] result in
            LoaderManager.shared.hide()
            switch result {
            case .success:
                self?.onSignUpSuccess?()
            case .failure(let error):
                self?.onSignUpError?(error.localizedDescription)
            }
        }
    }
}
