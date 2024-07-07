//
//  RunningCoordinator.swift
//  Coordinator
//
//  Created by 유현진 on 6/6/24.
//

import UIKit
import Presentation

class RunningCoordinator: Coordinator {
    
    private var navigationController: UINavigationController!
    var childCoordinator: [Coordinator] = []
    
    let runningDIContainer: RunningDIContainer
    
    var isFreeCourse: Bool = true
    
    public init(navigationController: UINavigationController) {
        self.navigationController = navigationController
        self.runningDIContainer = RunningDIContainer()
    }
    
    func start() {
        if isFreeCourse {
            let vc = runningDIContainer.makeRunningViewController(coordinator: self)
            self.navigationController.pushViewController(vc, animated: true)
        } else {
            let vc = runningDIContainer.makeRunningSettingViewController(coordinator: self)
            self.navigationController.pushViewController(vc, animated: true)
        }
    }
}

extension RunningCoordinator: RunningCoordinatorInterface {

}
