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
        self.navigationController.pushViewController(vc, animated: true)
    }
}

extension LoginCoordinator: LoginCoordinatorInterface{
    func successedSignIn(){
        self.delegate?.didLoggedIn(coordinator: self)
    }
    
    func showAccess() {
        let vc = loginDiContainer.makeAccessViewController(coordinator: self)
        self.navigationController.pushViewController(vc, animated: true)
    }
    
    func showAccessDetail(index: Int) {
        let vc = loginDiContainer.makeAccessDetailViewController(coordinator: self, index: index)
        self.navigationController.pushViewController(vc, animated: true)
    }
}

