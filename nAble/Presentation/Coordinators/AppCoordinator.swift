import UIKit
import FirebaseAuth

class AppCoordinator {
    private let window: UIWindow
    private var authCoordinator: AuthCoordinator?
    private var mainCoordinator: MainCoordinator?
    private var authRepo: AuthRepository
    
    init(window: UIWindow) {
        self.window = window
        self.authRepo = FirebaseAuthRepository()
    }
    
    func start() {
        let hasSeenOnboarding = UserDefaults.standard.bool(forKey: "hasSeenOnboarding")
        
        if hasSeenOnboarding {
            checkAuthAndShowScreen()
        } else {
            showOnboarding()
        }
    }
    
    private func checkAuthAndShowScreen() {
        if Auth.auth().currentUser != nil {
            showMainApp()
        } else {
            showAuth()
        }
    }
    
    func showMainApp() {
        
    }
    
    func showAuth() {
        
    }
    
    func showOnboarding() {
        
    }
    
    func createMainCoordinator(with user: User?) {
        let mainCoordinator = MainCoordinator(window: window, currentUser: user)
        mainCoordinator.delegate = self
        mainCoordinator.start()
        self.mainCoordinator = mainCoordinator
    }
    
    func onboardingDidFinish() {
        UserDefaults.standard.set(true, forKey: "hasSeenOnboarding")
        checkAuthAndShowScreen()
    }
}
