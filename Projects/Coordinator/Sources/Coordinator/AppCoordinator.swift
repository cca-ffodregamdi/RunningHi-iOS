//
//  AppCoordinator.swift
//  Coordinator
//
//  Created by 유현진 on 6/5/24.
//

import UIKit
import RxSwift
import RxCocoa

public class AppCoordinator: Coordinator{
    
    var disposeBag: DisposeBag = DisposeBag()
    var childCoordinator: [Coordinator] = []
    
    private var navigationController: UINavigationController!
    
    public init(navigationController: UINavigationController!) {
        self.navigationController = navigationController
    }
    
    public func start() {
        AuthManager.shared.isValidAccessToken()
            .bind{ bool in
                print(UserDefaults.standard.object(forKey: "accessToken"))
                if bool{
                    self.showBaseTabBarController()
                }else{
                    self.showLoginViewController()
                }
            }.disposed(by: self.disposeBag)
    }
    
    private func showBaseTabBarController(){
        self.navigationController.viewControllers.removeAll()
        let coordinator = BaseTabBarCoordinator(navigationController: self.navigationController)
        coordinator.start()
        self.childCoordinator.append(coordinator)
    }
    
    private func showLoginViewController(){
        let coordinator = LoginCoordinator(navigationController: self.navigationController)
        coordinator.start()
        coordinator.delegate = self
        self.childCoordinator.append(coordinator)
    }
}

extension AppCoordinator: LoginCoordinatorDelegate{
    func didLoggedIn(coordinator: LoginCoordinator) {
        self.childCoordinator = self.childCoordinator.filter{$0 !== coordinator}
        self.showBaseTabBarController()
    }
}
