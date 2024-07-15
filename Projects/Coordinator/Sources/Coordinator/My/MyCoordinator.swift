//
//  MyCoordinator.swift
//  Coordinator
//
//  Created by 유현진 on 6/6/24.
//

import UIKit
import Presentation

class MyCoordinator: Coordinator{
    var childCoordinator: [Coordinator] = []
    
    private var navigationController: UINavigationController!
    let myDIContainer: MyDIContainer
    
    public init(navigationController: UINavigationController) {
        self.navigationController = navigationController
        self.myDIContainer = MyDIContainer()
    }
    
    func start() {
        let vc = myDIContainer.makeMyViewController(coordinator: self)
        self.navigationController.pushViewController(vc, animated: true)
    }
}

extension MyCoordinator: MyCoordinatorInterface{
    func showNotice() {
        let vc = myDIContainer.makeNoticeViewController(coordinator: self)
        self.navigationController.pushViewController(vc, animated: true)
    }
}
