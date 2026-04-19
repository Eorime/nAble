import UIKit
import FirebaseAuth

protocol AuthCoordinatorDelegate: AnyObject {
    func authCoordinatorDidFinish(_ coordinator: AuthCoordinator)
    func authCoordinatorDidSkip(_ coordinator: AuthCoordinator)
}

class AuthCoordinator {
    private let window: UIWindow
    private let authRepository: AuthRepository
    weak var delegate: AuthCoordinatorDelegate?
    
    init(window: UIWindow) {
        self.window = window
        self.authRepository = FirebaseAuthRepository()
    }
    
    func start() {
        showLogin()
    }
    
    func showLogin() {
        let viewModel = LoginViewModel(authRepo: authRepository)
        let loginVC = LogInViewController(viewmodel: viewModel)
        loginVC.coordinator = self
        let navController = UINavigationController(rootViewController: loginVC)
        navController.setNavigationBarHidden(true, animated: false)
        window.rootViewController = navController
        window.makeKeyAndVisible()
    }
    
    func showSignUp() {
        let viewModel = SignUpViewModel()
        let signupVC = SignUpViewController(viewmodel: viewModel)
        signupVC.coordinator = self
        let navController = UINavigationController(rootViewController: signupVC)
        navController.setNavigationBarHidden(true, animated: false)
        window.rootViewController = navController
        window.makeKeyAndVisible()
    }
    
    func skipAuth() {
        delegate?.authCoordinatorDidSkip(self)
    }
    
    func loginDidSucceed() {
        delegate?.authCoordinatorDidFinish(self)
    }
    
    func signupDidSucceed() {
        delegate?.authCoordinatorDidFinish(self)
    }
}
