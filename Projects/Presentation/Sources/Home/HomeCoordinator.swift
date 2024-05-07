//
//  HomeCoordinator.swift
//  Presentation
//
//  Created by 유현진 on 5/3/24.
//

import UIKit

protocol HomeCoordinatorDelegate{
    func didloggedOut(coordinator: HomeCoordinator)
}

class HomeCoordinator: Coordinator{
    
    var delegate: HomeCoordinatorDelegate?
    
    var childCoordinator: [Coordinator] = []
    
    var navigationController: UINavigationController!
    
    init(navigationController: UINavigationController!) {
        self.navigationController = navigationController
    }
    
    func start() {
        let vc = HomeViewController()
        vc.delegate = self
        self.navigationController.viewControllers = [vc]
    }
}

extension HomeCoordinator: HomeViewControllerDelegate{
    func logout() {
        self.delegate?.didloggedOut(coordinator: self)
    }
}
