//
//  ChallengeCoordinator.swift
//  Presentation
//
//  Created by 유현진 on 5/28/24.
//

import UIKit
import Domain

class ChallengeCoordinator: Coordinator{
    var childCoordinator: [Coordinator] = []
    
    var navigationController: UINavigationController!
    
    init(navigationController: UINavigationController!) {
        self.navigationController = navigationController
    }
    
    func start() {
        let vc = ChallengeViewController(coordinator: self)
        navigationController.viewControllers = [vc]
    }
    
    func showChallengeDetail(model: ChallengeModel){
        let vc = ChallengeDetailViewController(challengeModel: model)
        navigationController.pushViewController(vc, animated: false)
    }
    
    deinit{
        print("deinit ChallengeCoordinator")
    }
}
