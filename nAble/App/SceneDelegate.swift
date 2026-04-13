//
//  SceneDelegate.swift
//  nAble
//
//  Created by Eorime on 05.04.26.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let scene = (scene as? UIWindowScene) else { return }
        
        window = UIWindow(windowScene: scene)
        
        //droebit nav controller iyos
        let navigation = UINavigationController(rootViewController: HomeView())
        window?.rootViewController = navigation
        window?.makeKeyAndVisible()
    }

  


}

