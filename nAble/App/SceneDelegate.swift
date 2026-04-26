import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?
    var appCoordinator: AppCoordinator?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let scene = (scene as? UIWindowScene) else { return }
        UINavigationBar.appearance().isHidden = true
        
        let window = UIWindow(windowScene: scene)
        self.window = window
        
        appCoordinator = AppCoordinator(window: window)
        appCoordinator?.start()
    }

}
