//
//  FeedCoordinator.swift
//  Coordinator
//
//  Created by 유현진 on 6/5/24.
//

import UIKit
import Presentation
class FeedCoordinator: Coordinator{
    
    var childCoordinator: [Coordinator] = []
    
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

extension FeedCoordinator: FeedCoordinatorInterface{
    
}
