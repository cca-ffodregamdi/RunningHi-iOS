//
//  HomeCoordinator.swift
//  Presentation
//
//  Created by 유현진 on 5/3/24.
//

import UIKit

class HomeCoordinator: Coordinator{
    
    var childCoordinator: [Coordinator] = []
    
    var navigationController: UINavigationController!
    
    init(navigationController: UINavigationController!) {
        self.navigationController = navigationController
    }
    
    func start() {
        let vc = HomeViewController()
        self.navigationController.viewControllers = [vc]
    }
    
    deinit{
        print("deinit HomeCoordinator")
    }
}

