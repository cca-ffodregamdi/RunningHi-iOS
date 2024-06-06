//
//  MyCoordinatorTest.swift
//  Coordinator
//
//  Created by 유현진 on 6/6/24.
//

import UIKit
import Presentation

class MyCoordinatorTest: CoordinatorTest{
    var childCoordinator: [CoordinatorTest] = []
    
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

extension MyCoordinatorTest: MyCoordinatorInterface{
    
}
