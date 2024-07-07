//
//  RunningCourseCoordinatorTest.swift
//  Coordinator
//
//  Created by 유현진 on 6/6/24.
//

import UIKit
import Presentation

class RunningCourseCoordinatorTest: Coordinator{
    
    private var navigationController: UINavigationController!
    var childCoordinator: [Coordinator] = []
    
//    let runningCourseDIContainer: RunningCourseDIContainer
    
    public init(navigationController: UINavigationController) {
        self.navigationController = navigationController
//        self.runningCourseDIContainer = RunningCourseDIContainer()
    }
    
    func start() {
//        let vc = runningCourseDIContainer.makeRunningCourseViewController(coordinator: self)
//        self.navigationController.pushViewController(vc, animated: true)
    }
}
extension RunningCourseCoordinatorTest: RunningCourseCoordinatorInterface{
    func didFinishCourse() {
        
    }
}
