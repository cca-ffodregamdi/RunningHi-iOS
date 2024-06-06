//
//  AppCoordinatorTest.swift
//  Coordinator
//
//  Created by 유현진 on 6/5/24.
//

import UIKit

public class AppCoordinatorTest: CoordinatorTest{
    
    
    var childCoordinator: [CoordinatorTest] = []
    
    private var navigationController: UINavigationController!
    
    public init(navigationController: UINavigationController!) {
        self.navigationController = navigationController
    }
    
    public func start() {
        if false{
            self.showBaseTabBarController()
        }else{
            self.showLoginViewController()
        }
    }
    
    private func showBaseTabBarController(){
        self.navigationController.viewControllers.removeAll()
        let coordinator = BaseTabBarCoordinatorTest(navigationController: self.navigationController)
        coordinator.start()
        self.childCoordinator.append(coordinator)
    }
    
    private func showLoginViewController(){
        let coordinator = LoginCoordinatorTest(navigationController: self.navigationController)
        coordinator.start()
        coordinator.delegate = self
        self.childCoordinator.append(coordinator)
    }
}

extension AppCoordinatorTest: LoginCoordinatorDelegateTest{
    func didLoggedIn(coordinator: LoginCoordinatorTest) {
        self.childCoordinator = self.childCoordinator.filter{$0 !== coordinator}
        self.showBaseTabBarController()
    }
}
