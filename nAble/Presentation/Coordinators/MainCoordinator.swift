import UIKit
import SwiftUI

protocol MainCoordinatorDelegate: AnyObject {
    func mainCoordinatorDidLogout(_ coordinator: MainCoordinator)
}

class MainCoordinator: NSObject, UINavigationControllerDelegate {
    private let window: UIWindow
    private var tabBarController: UITabBarController?
    private let currentUser: User?
    weak var delegate: MainCoordinatorDelegate?
    
    init(window: UIWindow, currentUser: User?) {
        self.window = window
        self.currentUser = currentUser
    }
    
    func start() {
        
    }
}

