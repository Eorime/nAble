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
        let tabBar = UITabBarController()
        
        let appearance = UITabBarAppearance()
        appearance.configureWithDefaultBackground()
        appearance.backgroundColor = UIColor(named: "AppGreen")
        
        appearance.shadowColor = nil
        appearance.shadowImage = nil
        
        tabBar.tabBar.standardAppearance = appearance  
        tabBar.tabBar.scrollEdgeAppearance = appearance
        
        let locationsView = LocationsView()
        let locationsVC = UIHostingController(rootView: locationsView)
        locationsVC.tabBarItem = UITabBarItem(title: "", image: UIImage(systemName: "location"), tag: 0)
        
        let homeView = HomeView()
        let homeVC = UIHostingController(rootView: homeView)
        homeVC.tabBarItem = UITabBarItem(title: "", image: UIImage(systemName: "map"), tag: 1)
        
        let profileView = ProfileView()
        let profileVC = UIHostingController(rootView: profileView)
        profileVC.tabBarItem = UITabBarItem(title: "", image: UIImage(systemName: "person"), tag: 2)
        
        tabBar.selectedIndex = 1
        tabBar.viewControllers = [locationsVC, homeVC, profileVC]
        
        window.rootViewController = tabBarController
        window.makeKeyAndVisible()
    }
}

