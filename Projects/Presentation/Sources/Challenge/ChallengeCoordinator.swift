//
//  ChallengeCoordinator.swift
//  Presentation
//
//  Created by 유현진 on 5/28/24.
//

import UIKit

class ChallengeCoordinator: Coordinator{
    var childCoordinator: [Coordinator] = []
    
    var navigationController: UINavigationController!
    
    init(navigationController: UINavigationController!) {
        self.navigationController = navigationController
    }
    
    func start() {
        let vc = ChallengeViewController()
        navigationController.viewControllers = [vc]
    }
    
    deinit{
        print("deinit ChallengeCoordinator")
    }
}
