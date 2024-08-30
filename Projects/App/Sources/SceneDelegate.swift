//
//  SceneDelegate.swift
//  RunningHi
//
//  Created by 유현진 on 5/1/24.
//

import UIKit
import KakaoSDKAuth
import Coordinator

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    var window: UIWindow?
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        sleep(2)
        guard let windowScene = (scene as? UIWindowScene) else { return }
        window = UIWindow(frame: windowScene.coordinateSpace.bounds)
        window?.windowScene = windowScene
        
        let navigationController = UINavigationController()
        navigationController.isNavigationBarHidden = true
        let coordinator = AppCoordinator(navigationController: navigationController)
        coordinator.start()
        
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
        window?.overrideUserInterfaceStyle = .light
    }
    
    func scene(_ scene: UIScene, openURLContexts URLContexts: Set<UIOpenURLContext>) {
        if let url = URLContexts.first?.url{
            if (AuthApi.isKakaoTalkLoginUrl(url)){
                _ = AuthController.handleOpenUrl(url: url)
            }
        }
    }
}
