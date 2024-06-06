//
//  ChallengeCoordinator.swift
//  Coordinator
//
//  Created by 유현진 on 6/5/24.
//

import UIKit
import Presentation
import Domain

class ChallengeCoordinator: Coordinator{
    
    var childCoordinator: [Coordinator] = []
    let challengeDIContainer: ChallengeDIContainer
    
    private let navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.challengeDIContainer = ChallengeDIContainer()
        self.navigationController = navigationController
    }
    
    func start() {
        let vc = challengeDIContainer.makeChallengeViewController(coordinator: self)
        self.navigationController.pushViewController(vc, animated: true)
    }
}

extension ChallengeCoordinator: ChallengeCoordinatorInterface{
    func showChallengeDetailView(model: ChallengeModel) {
        let vc = challengeDIContainer.makeChallengeDetailViewController(model: model, coordinator: self)
        self.navigationController.pushViewController(vc, animated: true)
    }
}
