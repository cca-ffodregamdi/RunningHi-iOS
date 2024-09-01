//
//  RunningCoordinator.swift
//  Coordinator
//
//  Created by 유현진 on 6/6/24.
//

import UIKit
import Presentation
import Domain

protocol RunningCoordinatorDelegate: AnyObject{
    func finishRunning(coordinator: RunningCoordinator)
}

class RunningCoordinator: Coordinator {
    
    private var navigationController: UINavigationController!
    
    var childCoordinator: [Coordinator] = []
    var delegate: RunningCoordinatorDelegate?
    let runningDIContainer: RunningDIContainer
    
    var isFreeCourse: Bool = true
    
    public init(navigationController: UINavigationController) {
        self.navigationController = navigationController
        self.runningDIContainer = RunningDIContainer()
    }
    
    func start() {
        if isFreeCourse {
            let vc = runningDIContainer.makeRunningViewController(coordinator: self, settingType: nil)
            self.navigationController.pushViewController(vc, animated: true)
        } else {
            let vc = runningDIContainer.makeRunningSettingViewController(coordinator: self)
            self.navigationController.pushViewController(vc, animated: true)
        }
    }
}

extension RunningCoordinator: RunningCoordinatorInterface {
    func startRunning(settingType: RunningSettingType, value: Int) {
        let vc = runningDIContainer.makeRunningViewController(coordinator: self, settingType: settingType, value: value)
        self.navigationController.pushViewController(vc, animated: true)
    }
    
    func showRunningResult(runningResult: RunningResult) {
        let vc = runningDIContainer.makeRunningResultViewController(coordinator: self, runningResult: runningResult)
        self.navigationController.pushViewController(vc, animated: true)
    }
    
    func showEditFeed(postNo: Int) {
        let feedCoordinator: FeedCoordinator = FeedCoordinator(navigationController: navigationController)
        let feedDIContainer = feedCoordinator.feedDIContainer
        
        let vc = feedDIContainer.makeEditPostViewController(postId: postNo, coordinator: feedCoordinator, enterType: .running, isPosted: false)
        self.navigationController.pushViewController(vc, animated: true)
    }
    
    func finishRunning() {
        self.navigationController?.isNavigationBarHidden = true
        delegate?.finishRunning(coordinator: self)
    }
}
