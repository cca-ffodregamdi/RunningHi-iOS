//
//  RunningDIContainer.swift
//  Coordinator
//
//  Created by 유현진 on 6/6/24.
//

import Foundation
import Presentation

class RunningDIContainer{
    func makeRunningViewController(coordinator: RunningCoordinator) -> RunningViewController{
        let vc = RunningViewController()
        vc.coordinator = coordinator
        return vc
    }
}
