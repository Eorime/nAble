import UIKit

class LoginViewModel {
    private let loginUseCase: LoginUseCase
    private let authRepo: AuthRepository
    
    var onLoginScreen: (() -> Void)?
    var onLoginError: ((String) -> Void)?
    
    init(authRepo: AuthRepository) {
        self.authRepo = authRepo
        self.loginUseCase = LoginUseCase(authRepo: authRepo)
    }
}
