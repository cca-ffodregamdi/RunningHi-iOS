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
    func showChallengeDetailView(viewController: ChallengeViewController, challengeId: Int, isParticipated: Bool) {
        let vc = challengeDIContainer.makeChallengeDetailViewController(challengeId: challengeId, isParticipated: isParticipated, coordinator: self)
        vc.delegate = viewController
        self.navigationController.pushViewController(vc, animated: true)
    }
}
