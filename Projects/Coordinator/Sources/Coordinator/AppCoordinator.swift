//
//  AppCoordinator.swift
//  Coordinator
//
//  Created by 유현진 on 6/5/24.
//

import UIKit
import RxSwift
import RxCocoa
import Data
import Common

public class AppCoordinator: Coordinator{
    
    var disposeBag: DisposeBag = DisposeBag()
    
    var childCoordinator: [Coordinator] = []
    
    private var navigationController: UINavigationController!
    
    public init(navigationController: UINavigationController!) {
        self.navigationController = navigationController
    }
    
    public func start() {
        if UserDefaultsManager.get(forKey: .isFirstKey) == nil {
            UserDefaultsManager.set(to: true, forKey: .isFirstKey)
            KeyChainManager.reset()
        }
        
        AuthManager.shared.isValidAccessToken()
            .bind{ bool in
                print(KeyChainManager.read(key: .runningHiAccessTokenkey))
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
        coordinator.delegate = self
        self.childCoordinator.append(coordinator)
    }
    
    private func showLoginViewController(){
        let coordinator = LoginCoordinator(navigationController: self.navigationController)
        coordinator.start()
        coordinator.delegate = self
        self.childCoordinator.append(coordinator)
    }
    
    private func showRunningViewController(isFreeCourse: Bool) {
        let coordinator = RunningCoordinator(navigationController: self.navigationController)
        coordinator.isFreeCourse = isFreeCourse
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

extension AppCoordinator: BaseTabBarCoordinatorDelegate{
    func showRunning(isFreeCourse: Bool) {
        self.showRunningViewController(isFreeCourse: isFreeCourse)
    }
    
    func backLogin(coordinator: BaseTabBarCoordinator) {
        self.childCoordinator = self.childCoordinator.filter{$0 !== coordinator}
        self.showLoginViewController()
    }
}

extension AppCoordinator: RunningCoordinatorDelegate{
    func finishRunning(coordinator: RunningCoordinator) {
        self.childCoordinator = self.childCoordinator.filter{$0 !== coordinator}
        self.navigationController.popToRootViewController(animated: true)
    }
}
