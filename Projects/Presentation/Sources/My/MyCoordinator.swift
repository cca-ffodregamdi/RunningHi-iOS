//
//  MyCoordinator.swift
//  Presentation
//
//  Created by 유현진 on 5/17/24.
//

import UIKit

class MyCoordinator: Coordinator{
    
    var childCoordinator: [Coordinator] = []
    
    private var navigationController: UINavigationController!
    
    public init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let vc = MyViewController()
        self.navigationController.viewControllers = [vc]
    }
    
    
    deinit{
        print("deinit MyCoordinator")
    }
}
