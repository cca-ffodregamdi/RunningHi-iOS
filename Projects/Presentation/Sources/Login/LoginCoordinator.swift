//
//  LoginCoordinator.swift
//  Presentation
//
//  Created by 유현진 on 5/3/24.
//

import UIKit

protocol LoginCoordinatorDelegate: AnyObject{
    func didLoggedIn(coordinator: LoginCoordinator)
}

public class LoginCoordinator: Coordinator, LoginViewControllerDelegate{
    
    var delegate: LoginCoordinatorDelegate?
    
    var childCoordinator: [Coordinator] = []
    
    private var navigationController: UINavigationController!
    
    public init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
//        let vc = LoginViewController()
//        vc.delegate = self
//        self.navigationController.viewControllers = [vc]
    }
    
    deinit{
        print("deinit LoginCoordinator")
    }
    
    public func login() {
        self.delegate?.didLoggedIn(coordinator: self)
    }
}
