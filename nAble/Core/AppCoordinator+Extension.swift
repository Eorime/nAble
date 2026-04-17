import UIKit

extension AppCoordinator: AuthCoordinatorDelegate {
    func authCoordinatorDidFinish(_ coordinator: AuthCoordinator) {
        showMainApp()
    }
    
    func authCoordinatorDidSkip(_ coordinator: AuthCoordinator) {
        createMainCoordinator(with: nil)
    }
}

extension AppCoordinator: MainCoordinatorDelegate {
    func mainCoordinatorDidLogout(_ coordinator: MainCoordinator) {
        showAuth()
    }
}
