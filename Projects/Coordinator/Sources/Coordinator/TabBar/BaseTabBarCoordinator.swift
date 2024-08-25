//
//  BaseTabBarCoordinator.swift
//  Coordinator
//
//  Created by 유현진 on 6/5/24.
//

import UIKit
import Presentation

protocol BaseTabBarCoordinatorDelegate: AnyObject{
    func showRunning(isFreeCourse: Bool)
    func backLogin(coordinator: BaseTabBarCoordinator)
}

class BaseTabBarCoordinator: Coordinator {
    
    var tabBarController: UITabBarController?
    var childCoordinator: [Coordinator] = []
    var delegate: BaseTabBarCoordinatorDelegate?
    
    let tabBarDIContainer: TabBarDIContainer
    
    private var navigationController: UINavigationController!
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
        self.tabBarDIContainer = TabBarDIContainer()
    }
    
    func start() {
        let pages: [TabBarItemType] = TabBarItemType.allCases
        let tabBarItems: [UITabBarItem] = pages.map{ self.createTabBarItem(type: $0) }
        let controllers: [UINavigationController] = tabBarItems.map{
            self.createTabNavigationController(tabBarItem: $0)
        }
        controllers.forEach{self.startTabCoordinator(tabNavigationController: $0)}
        
        self.tabBarController = tabBarDIContainer.makeTabBarController(coordinator: self)
        self.configureTabBarController(tabNavigationController: controllers)
        self.addTabBarController()
    }
    
    private func createTabBarItem(type: TabBarItemType) -> UITabBarItem{
        return UITabBarItem(
            title: type.getTitle(),
            image: type.getImage(),
            tag: type.getNumber()
        )
    }
    
    private func createTabNavigationController(tabBarItem: UITabBarItem) -> UINavigationController{
        let tabNavigationController = UINavigationController()
        tabNavigationController.setNavigationBarHidden(false, animated: false)
        tabNavigationController.tabBarItem = tabBarItem
        return tabNavigationController
    }
    
    private func startTabCoordinator(tabNavigationController: UINavigationController){
        let tabBarItemTag: Int = tabNavigationController.tabBarItem.tag
        guard let tabBarItemType: TabBarItemType = TabBarItemType(index: tabBarItemTag) else { return }
        
        switch tabBarItemType{
        case .Feed:
            let feedCoordinator: FeedCoordinator = FeedCoordinator(navigationController: tabNavigationController)
            self.childCoordinator.append(feedCoordinator)
            feedCoordinator.start()
            tabNavigationController.viewControllers.first?.title = TabBarItemType.Feed.getTitle()
        case .Challenge:
            let challengeCoordinator: ChallengeCoordinator = ChallengeCoordinator(navigationController: tabNavigationController)
            self.childCoordinator.append(challengeCoordinator)
            challengeCoordinator.start()
            tabNavigationController.viewControllers.first?.title = TabBarItemType.Challenge.getTitle()
        case .Course:
            return
        case .Record:
            let recordCoordinator: RecordCoordinator = RecordCoordinator(navigationController: tabNavigationController)
            self.childCoordinator.append(recordCoordinator)
            recordCoordinator.start()
            tabNavigationController.viewControllers.first?.title = TabBarItemType.Record.getTitle()
        case .My:
            let myCoordinator: MyCoordinator = MyCoordinator(parentCoordinator: self, navigationController: tabNavigationController)
            self.childCoordinator.append(myCoordinator)
            myCoordinator.start()
            tabNavigationController.viewControllers.first?.title = TabBarItemType.My.getTitle()
        }
    }
    
    private func configureTabBarController(tabNavigationController: [UIViewController]){
        if let tabBarController = tabBarController {
            tabBarController.setViewControllers(tabNavigationController, animated: false)
            tabBarController.selectedIndex = TabBarItemType.Feed.getNumber()
            tabBarController.view.backgroundColor = .systemBackground
            tabBarController.tabBar.backgroundColor = .systemBackground
            tabBarController.tabBar.tintColor = .black
        }
    }
    
    private func addTabBarController(){
        if let tabBarController = tabBarController {
            self.navigationController.pushViewController(tabBarController, animated: true)
        }
    }
}

extension BaseTabBarCoordinator: TabBarCoordinatorInterface {
    
    func showRunningPopup(_ viewController: UIViewController) {
        if let tabBarController = tabBarController {
            let runningPopupVC = tabBarDIContainer.makeRunningPopupViewController()
            runningPopupVC.coordinator = self
            runningPopupVC.rootViewController = viewController
            runningPopupVC.tabViewController = tabBarController
            runningPopupVC.modalPresentationStyle = .overFullScreen
            viewController.parent?.present(runningPopupVC, animated: false, completion: nil)
        }
    }
    
    func cancelRunningPopup(_ viewController: UIViewController) {
        viewController.parent?.dismiss(animated: false)
    }
    
    func showRunning(isFreeCourse: Bool) {
        self.delegate?.showRunning(isFreeCourse: isFreeCourse)
    }
}
