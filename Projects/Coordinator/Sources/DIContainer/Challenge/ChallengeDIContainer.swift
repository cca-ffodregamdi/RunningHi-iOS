//
//  ChallengeDIContainer.swift
//  Coordinator
//
//  Created by 유현진 on 6/5/24.
//

import Foundation
import Presentation
import Data
import Domain

class ChallengeDIContainer{
    
    private lazy var challengeRepository: ChallengeRepositoryImplementation = {
        return ChallengeRepositoryImplementation()
    }()
    
    private lazy var challengeUseCase: ChallengeUseCase = {
        return ChallengeUseCase(repository: challengeRepository)
    }()
    
    func makeChallengeViewController(coordinator: ChallengeCoordinator) -> ChallengeViewController{
        let challengeUseCase = challengeUseCase
        let vc = ChallengeViewController(reactor: ChallengeReactor(challengeUseCase: challengeUseCase))
        vc.coordinator = coordinator
        return vc
    }
    
    func makeChallengeDetailViewController(model: ChallengeModel, coordinator: ChallengeCoordinator) -> ChallengeDetailViewController{
        let challengeUseCase = challengeUseCase
        let vc = ChallengeDetailViewController(challengeModel: model, reactor: ChallengeDetailReactor(challengeUseCase: challengeUseCase))
        vc.coordinator = coordinator
        return vc
    }

}
