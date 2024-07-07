//
//  RunningDIContainer.swift
//  Coordinator
//
//  Created by 유현진 on 6/6/24.
//

import Foundation
import Presentation
import Domain
import Data

class RunningDIContainer{
    private lazy var runningRepository: RunningRepositoryImplementation = {
        return RunningRepositoryImplementation()
    }()
    
    private lazy var runningUseCase: RunningUseCase = {
        return RunningUseCase(repository: runningRepository)
    }()
    
    func makeRunningViewController(coordinator: RunningCoordinator) -> RunningViewController{
        let vc = RunningViewController(reactor: RunningReactor(runningUseCase: runningUseCase))
        vc.coordinator = coordinator
        return vc
    }
    
    func makeRunningSettingViewController(coordinator: RunningCoordinator) -> RunningSettingViewController{
        let vc = RunningSettingViewController()
        vc.coordinator = coordinator
        return vc
    }
    
    func makeRunningResultViewController(coordinator: RunningCoordinator) -> RunningResultViewController{
        let vc = RunningResultViewController()
        vc.coordinator = coordinator
        return vc
    }
}
