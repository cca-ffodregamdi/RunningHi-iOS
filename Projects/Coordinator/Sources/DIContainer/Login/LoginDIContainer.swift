//
//  LoginDIContainer.swift
//  Coordinator
//
//  Created by 유현진 on 6/5/24.
//

import Foundation

import Presentation
import Data
import Domain

class LoginDIContainer{
    
    private lazy var loginRepository: LoginRepositoryImplementation = {
        return LoginRepositoryImplementation()
    }()
    
    private lazy var loginUseCase: LoginUseCase = {
        return LoginUseCase(loginRepository: loginRepository)
    }()
    
    func makeLoginViewController(coordinator: LoginCoordinator) -> LoginViewController{
        let loginUseCase = loginUseCase
        let vc = LoginViewController(reactor: LoginReactor(loginUseCase: loginUseCase))
        vc.coordinator = coordinator
        return vc
    }
    
    func makeAccessViewController(coordinator: LoginCoordinator) -> AccessViewController{
        let vc = AccessViewController(reactor: AccessReactor(loginUseCase: loginUseCase))
        vc.coordinator = coordinator
        return vc
    }
    
    func makeAccessDetailViewController(coordinator: LoginCoordinator, index: Int) -> AccessDetailViewController{
        let vc = AccessDetailViewController(reactor: AccessDetailReactor(index: index))
        return vc
    }
}
