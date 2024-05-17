//
//  SplashCoordinator.swift
//  Presentation
//
//  Created by 유현진 on 5/16/24.
//

import UIKit

final public class SplashCoordinator: Coordinator{
   
    var childCoordinator: [Coordinator] = []
    
    private var navigationController: UINavigationController!
    
    public init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    public func start() {
        let vc = SplashViewController()
        vc.delegate = self
        self.navigationController.viewControllers = [vc]
    }
    
    deinit{
        print("deinit SplashCoordinator")
    }
}

extension SplashCoordinator: SplashViewControllerDelegate{
    func pushApp() {
        self.navigationController.viewControllers.removeAll()
        let coordinator = AppCoordinator(navigationController: navigationController)
        coordinator.start()
    }
}
