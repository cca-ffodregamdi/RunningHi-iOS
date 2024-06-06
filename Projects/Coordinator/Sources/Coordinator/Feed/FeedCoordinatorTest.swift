//
//  FeedCoordinatorTest.swift
//  Coordinator
//
//  Created by 유현진 on 6/5/24.
//

import UIKit
import Presentation
class FeedCoordinatorTest: CoordinatorTest{
    
    var childCoordinator: [CoordinatorTest] = []
    
    private var navigationController: UINavigationController!
    
    let feedDIContainer: FeedDIContainer
    
    init(navigationController: UINavigationController!) {
        self.navigationController = navigationController
        feedDIContainer = FeedDIContainer()
    }
    
    func start() {
        let vc = feedDIContainer.makeFeedViewController(coordinator: self)
        self.navigationController.pushViewController(vc, animated: true)
    }
}

extension FeedCoordinatorTest: FeedCoordinatorInterface{
    
}
