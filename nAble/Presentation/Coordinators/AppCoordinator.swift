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
        checkAuthAndShowScreen()
    }
    
    private func checkAuthAndShowScreen() {
        if Auth.auth().currentUser != nil {
            showMainApp()
        } else {
            showAuth()
        }
    }
    
    func showMainApp() {
        if let firebaseUser = Auth.auth().currentUser {
            guard let firebaseAuthRepo = authRepo as? FirebaseAuthRepository else {
                self.showAuth()
                return
            }
            
            firebaseAuthRepo.fetchUser(userId: firebaseUser.uid) { result in
                DispatchQueue.main.async {
                    switch result {
                    case .success(let user):
                        self.createMainCoordinator(with: user)
                    case .failure(_):
                        print("Failed to fetch user, appcoordinator")
                        self.showAuth()
                    }
                }
            }
        } else {
            createMainCoordinator(with: nil)
        }
    }
    
    func showAuth() {
        let authCoordinator = AuthCoordinator(window: window)
        authCoordinator.delegate = self
        authCoordinator.start()
        self.authCoordinator = authCoordinator
    }
    
    func createMainCoordinator(with user: User?) {
        let mainCoordinator = MainCoordinator(window: window, currentUser: user)
        mainCoordinator.delegate = self
        mainCoordinator.start()
        self.mainCoordinator = mainCoordinator
    }
}
