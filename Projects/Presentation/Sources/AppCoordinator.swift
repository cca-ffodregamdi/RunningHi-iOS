//
//  AppCoorinator.swift
//  Presentation
//
//  Created by 유현진 on 5/3/24.
//

import UIKit

final public class AppCoordinator: Coordinator{
    
    var childCoordinator: [Coordinator] = []
    
    private var navigationController: UINavigationController!
    
    private var isLoggedIn: Bool = false
    
    public init(navigationController: UINavigationController!) {
        self.navigationController = navigationController
    }
    
    public func start() {
//        if let object = UserDefaults.standard.object(forKey: "accessToken"){
        if isLoggedIn{
            self.showBaseTabBarController()
        }else{
            self.showLoginViewController()
        }
    }
    
    private func showBaseTabBarController(){
        let coordinator = BaseTabBarCoordinator(navigationController: self.navigationController)
        coordinator.start()
        self.childCoordinator.append(coordinator)
    }
    
    private func showLoginViewController(){
        let coordinator = LoginCoordinator(navigationController: self.navigationController)
        coordinator.delegate = self
        coordinator.start()
        self.childCoordinator.append(coordinator)
    }
}

extension AppCoordinator: LoginCoordinatorDelegate{
    func didLoggedIn(coordinator: LoginCoordinator) {
        self.childCoordinator = self.childCoordinator.filter{$0 !== coordinator}
        self.navigationController.viewControllers.removeAll()
        self.showBaseTabBarController()
    }
}

