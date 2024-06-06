//
//  LoginCoordinatorTest.swift
//  Coordinator
//
//  Created by 유현진 on 6/5/24.
//

import Presentation
import UIKit

protocol LoginCoordinatorDelegateTest: AnyObject{
    func didLoggedIn(coordinator: LoginCoordinatorTest)
}

class LoginCoordinatorTest: CoordinatorTest{
    
    private let navigationController: UINavigationController
    
    var childCoordinator: [CoordinatorTest] = []
    var delegate: LoginCoordinatorDelegateTest?
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

//extension LoginCoordinatorTest: LoginViewControllerDelegate{
//    func login(){
//        self.delegate?.didLoggedIn(coordinator: self)
//    }
//}

extension LoginCoordinatorTest: LoginCoordinatorInterface{
    func login(){
        self.delegate?.didLoggedIn(coordinator: self)
    }
}

