//
//  LoginCoordinator.swift
//  Coordinator
//
//  Created by 유현진 on 6/5/24.
//

import Presentation
import UIKit

protocol LoginCoordinatorDelegate: AnyObject{
    func didLoggedIn(coordinator: LoginCoordinator)
}

class LoginCoordinator: Coordinator{
    
    private let navigationController: UINavigationController
    
    var childCoordinator: [Coordinator] = []
    var delegate: LoginCoordinatorDelegate?
    let loginDiContainer: LoginDIContainer
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
        self.loginDiContainer = LoginDIContainer()
    }
    
    func start() {
        let vc = loginDiContainer.makeLoginViewController(coordinator: self)
        navigationController.pushViewController(vc, animated: true)
    }
}

extension LoginCoordinator: LoginCoordinatorInterface{
    func login(){
        self.delegate?.didLoggedIn(coordinator: self)
    }
}

