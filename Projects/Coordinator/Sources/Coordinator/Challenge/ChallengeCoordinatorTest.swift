//
//  ChallengeCoordinatorTest.swift
//  Coordinator
//
//  Created by 유현진 on 6/5/24.
//

import UIKit
import Presentation

class ChallengeCoordinatorTest: CoordinatorTest{
    
    var childCoordinator: [CoordinatorTest] = []
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
extension ChallengeCoordinatorTest: ChallengeCoordinatorInterface{
    func showChallengeDetailView() {
        
    }
}
