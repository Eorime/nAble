import UIKit
import SwiftUI

protocol MainCoordinatorDelegate: AnyObject {
    func mainCoordinatorDidLogout(_ coordinator: MainCoordinator)
}

class CustomTabBarController: UITabBarController {
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        var frame = tabBar.frame
        frame.size.height = 90
        frame.origin.y = view.frame.size.height - 90
        tabBar.frame = frame
    }
}

class MainCoordinator: NSObject, UINavigationControllerDelegate {
    private let window: UIWindow
    private var tabBarController: UITabBarController?
    private let currentUser: User?
    private let di: AppDIContainer
    
    weak var delegate: MainCoordinatorDelegate?
    
    init(window: UIWindow, currentUser: User?, di: AppDIContainer = AppDIContainer()) {
        self.window = window
        self.currentUser = currentUser
        self.di = di
    }
    
    func start() {
        UINavigationBar.appearance().isHidden = true
        let tabBar = CustomTabBarController()
        let symbolConfig = UIImage.SymbolConfiguration(pointSize: 21, weight: .medium)
        
        let appearance = UITabBarAppearance()
        appearance.backgroundColor = UIColor(named: "AppBG")
        appearance.shadowColor = nil
        appearance.shadowImage = nil
        
        let itemAppearance = UITabBarItemAppearance()
        itemAppearance.selected.iconColor = UIColor(named: "AppGreen")
        itemAppearance.selected.titleTextAttributes = [.foregroundColor: UIColor(named: "AppGreen")!]
        itemAppearance.normal.iconColor = UIColor(named: "AppGreen")?.withAlphaComponent(0.5)
        appearance.stackedLayoutAppearance = itemAppearance
        tabBar.tabBar.standardAppearance = appearance
        tabBar.tabBar.scrollEdgeAppearance = appearance
        
        let placesVM = PlacesViewModel(
            userId: currentUser?.id ?? "",
            locationService: di.locationService
        )
        let placesVC = UIHostingController(rootView: PlacesView(viewModel: placesVM))
        placesVC.tabBarItem = UITabBarItem(title: "", image: UIImage(systemName: "location", withConfiguration: symbolConfig), tag: 0)
        
        let homeVM = HomeViewModel(
            getCurrentLocation: di.getCurrentLocationUseCase,
            locationService: di.locationService,
            addLocationUseCase: di.addLocationUseCase,
            getAllLocationsUseCase: di.getAllLocationsUseCase,
            removeLocationUseCase: di.removeLocationUseCase,
            imageRepository: di.imageRepository
        )
        homeVM.profile = currentUser
        let homeVC = UIHostingController(rootView: HomeView(viewModel: homeVM))
        homeVC.tabBarItem = UITabBarItem(title: "", image: UIImage(systemName: "map", withConfiguration: symbolConfig), tag: 1)
        
        let profileVM = ProfileViewModel(
            profile: currentUser,
            fetchSavedPlacesUseCase: di.fetchSavedPlacesUseCase,
            getLocationsUseCase: di.getLocationsUseCase,
            logoutUseCase: di.logoutUseCase,
            deleteAccountUseCase: di.deleteAccountUseCase,
            updateFullNameUseCase: di.updateFullNameUseCase,
            updateUsernameUseCase: di.updateUsernameUseCase,
            removeLocationUseCase: di.removeLocationUseCase,
            removeSavedPlaceUseCase: di.removeSavedPlaceUseCase,
            updateAvatarUseCase: di.updateAvatarUseCase
        )
        profileVM.coordinator = self.delegate as? AppCoordinator
        let profileVC = UIHostingController(rootView: ProfileView(vm: profileVM))
        profileVC.tabBarItem = UITabBarItem(title: "", image: UIImage(systemName: "person", withConfiguration: symbolConfig), tag: 2)
        
        tabBar.viewControllers = [placesVC, homeVC, profileVC]
        tabBar.selectedIndex = 1
        window.rootViewController = tabBar
        window.makeKeyAndVisible()
    }
}
