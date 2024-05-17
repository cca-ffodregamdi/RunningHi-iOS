//
//  AppCoorinator.swift
//  Presentation
//
//  Created by 유현진 on 5/3/24.
//

import UIKit

final public class AppCoordinator: Coordinator{
    
    var childCoordinator: [Coordinator] = []
    
    private var navigationController: UINavigationController!
    
    public init(navigationController: UINavigationController!) {
        self.navigationController = navigationController
    }
    
    public func start() {
        // TODO: 토큰 유효성 검증, 백엔드 API 추가되면 적용
        // TODO: splash 에서 검증 후 start()에 매개변수로 전달?
//        if let object = UserDefaults.standard.object(forKey: "accessToken"){
        if false{
            self.showBaseTabBarController()
        }else{
            self.showLoginViewController()
        }
    }
    
    private func showBaseTabBarController(){
        let coordinator = BaseTabBarCoordinator(navigationController: self.navigationController)
        coordinator.start()
        self.childCoordinator.append(coordinator)
    }
    
    private func showLoginViewController(){
        let coordinator = LoginCoordinator(navigationController: self.navigationController)
        coordinator.delegate = self
        coordinator.start()
        self.childCoordinator.append(coordinator)
    }
}

extension AppCoordinator: LoginCoordinatorDelegate{
    func didLoggedIn(coordinator: LoginCoordinator) {
        self.childCoordinator = self.childCoordinator.filter{$0 !== coordinator}
        self.navigationController.viewControllers.removeAll()
        self.showBaseTabBarController()
    }
}

