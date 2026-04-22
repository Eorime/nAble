import UIKit

class LoginViewModel {
    private let loginUseCase: LoginUseCase
    private let authRepo: AuthRepository
    
    var onLoginSuccess: (() -> Void)?
    var onLoginError: ((String) -> Void)?
    
    init(authRepo: AuthRepository) {
        self.authRepo = authRepo
        self.loginUseCase = LoginUseCase(authRepo: authRepo)
    }
    
    func login(email: String, password: String) {
        if let validationError = validateLoginInputs(email: email, password: password) {
            onLoginError?(validationError)
            return
        }
        
        LoaderManager.shared.show()
        loginUseCase.execute(email: email, password: password) { [weak self] result in
            DispatchQueue.main.async {
                LoaderManager.shared.hide()
                
                switch result {
                case .success:
                    self?.onLoginSuccess?()
                case .failure(let error):
                    let errorMessage = self?.mapFirebaseError(error) ?? error.localizedDescription
                    self?.onLoginError?(errorMessage)
                }
            }
        }
    }
    
    //aq googleitac mere
    private func isValidEmail(_ email: String) -> Bool {
           let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
           let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
           return emailPredicate.evaluate(with: email)
       }
       
    private func validateLoginInputs(email: String, password: String) -> String? {
        guard !email.isEmpty else {
            return "Email is required"
        }
           
        guard isValidEmail(email) else {
            return "Please enter a valid email address"
        }
           
        guard !password.isEmpty else {
            return "Password is required"
        }
           
        return nil
    }
    
    private func mapFirebaseError(_ error: Error) -> String {
            let errorCode = (error as NSError).code
            
            switch errorCode {
            case 17011:
                return "No account found with this email"
            case 17009:
                return "Incorrect password"
            case 17008:
                return "Invalid email address"
            case 17010:
                return "This account has been disabled"
            case 17020:
                return "Network error. Please check your connection"
            default:
                return error.localizedDescription
            }
        }
}

//TODO: places ro daachers, mapze current lokaciidan manamde marshruti, but also details page tavisi reviewebit (sheet ufro saidanac mapze gadavalt)
//TODO: useris mier adgilis damatebis funqcionali fototi
