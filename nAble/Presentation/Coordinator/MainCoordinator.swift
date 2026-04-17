import UIKit
import SwiftUI

protocol MainCoordinatorDelegate: AnyObject {
    func mainCoordinatorDidLogout(_coordinator: MainCoordinator)
}

class MainCoordinator: NSObject, UINavigationControllerDelegate {
    
}

