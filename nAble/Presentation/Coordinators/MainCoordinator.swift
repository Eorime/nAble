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
        UINavigationBar.appearance().isHidden = true
        let tabBar = UITabBarController()
        let symbolConfig = UIImage.SymbolConfiguration(pointSize: 21, weight: .medium)
        
        let appearance = UITabBarAppearance()
        appearance.configureWithTransparentBackground()
        appearance.backgroundColor = .clear
        
        appearance.shadowColor = nil
        appearance.shadowImage = nil
        
        let itemAppearance = UITabBarItemAppearance()
        itemAppearance.selected.iconColor = UIColor(named: "AppGreen")
        itemAppearance.selected.titleTextAttributes = [.foregroundColor: UIColor(named: "AppGreen")!]
        itemAppearance.normal.iconColor = UIColor(named: "AppGreen")?.withAlphaComponent(0.5)
        appearance.stackedLayoutAppearance = itemAppearance
        
        tabBar.tabBar.standardAppearance = appearance
        tabBar.tabBar.scrollEdgeAppearance = appearance
        
        let placesView = PlacesView()
        let placesVC = UIHostingController(rootView: placesView)
        placesVC.tabBarItem = UITabBarItem(title: "", image: UIImage(systemName: "location", withConfiguration: symbolConfig), tag: 0)
        
        let homeView = HomeView()
        let homeVC = UIHostingController(rootView: homeView)
        homeVC.tabBarItem = UITabBarItem(title: "", image: UIImage(systemName: "map", withConfiguration: symbolConfig), tag: 1)
        
        let profileView = ProfileView()
        let profileVC = UIHostingController(rootView: profileView)
        profileVC.tabBarItem = UITabBarItem(title: "", image: UIImage(systemName: "person", withConfiguration: symbolConfig), tag: 2)
        
        tabBar.selectedIndex = 1
        tabBar.viewControllers = [placesVC, homeVC, profileVC]
        
        window.rootViewController = tabBar
        window.makeKeyAndVisible()
    }
}

