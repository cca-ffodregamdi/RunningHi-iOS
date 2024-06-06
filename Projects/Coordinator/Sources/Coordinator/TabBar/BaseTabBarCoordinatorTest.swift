//
//  BaseTabBarCoordinatorTest.swift
//  Coordinator
//
//  Created by 유현진 on 6/5/24.
//

import UIKit
import Common

class BaseTabBarCoordinatorTest: TabBarCoordinatorTest{
    var tabBarController: UITabBarController
    
    var childCoordinator: [CoordinatorTest] = []
    
    private var navigationController: UINavigationController!
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
        self.tabBarController = UITabBarController()
    }
    
    func start() {
        let pages: [TabBarItemTypeTest] = TabBarItemTypeTest.allCases
        let tabBarItems: [UITabBarItem] = pages.map{ self.createTabBarItem(type: $0) }
        let controllers: [UINavigationController] = tabBarItems.map{
            self.createTabNavigationController(tabBarItem: $0)
        }
        controllers.forEach{self.startTabCoordinator(tabNavigationController: $0)}
        self.configureTabBarController(tabNavigationController: controllers)
        self.addTabBarController()
    }
    
    private func createTabBarItem(type: TabBarItemTypeTest) -> UITabBarItem{
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
        guard let tabBarItemType: TabBarItemTypeTest = TabBarItemTypeTest(index: tabBarItemTag) else { return }
        
        switch tabBarItemType{
        case .Feed:
            let feedCoordinator: FeedCoordinatorTest = FeedCoordinatorTest(navigationController: tabNavigationController)
            self.childCoordinator.append(feedCoordinator)
            feedCoordinator.start()
        case .Challenge:
            let challengeCoordinator: ChallengeCoordinatorTest = ChallengeCoordinatorTest(navigationController: tabNavigationController)
            self.childCoordinator.append(challengeCoordinator)
            challengeCoordinator.start()
            tabNavigationController.viewControllers.first?.title = TabBarItemTypeTest.Challenge.getTitle()
        case .Course:
            break
//            let courseCoordinator: RunningCourseCoordinator = RunningCourseCoordinator(navigationController: tabNavigationController)
//            self.childCoordinator.append(courseCoordinator)
//            courseCoordinator.start()
        case .Rank:
            return
        case .My:
            let myCoordinator: MyCoordinatorTest = MyCoordinatorTest(navigationController: tabNavigationController)
            self.childCoordinator.append(myCoordinator)
            myCoordinator.start()
            tabNavigationController.viewControllers.first?.title = TabBarItemTypeTest.My.getTitle()
        }
    }
    
    private func configureTabBarController(tabNavigationController: [UIViewController]){
        self.tabBarController.setViewControllers(tabNavigationController, animated: false)
        self.tabBarController.selectedIndex = TabBarItemTypeTest.Feed.getNumber()
        self.tabBarController.view.backgroundColor = .systemBackground
        self.tabBarController.tabBar.backgroundColor = .systemBackground
        self.tabBarController.tabBar.tintColor = .black
        
    }
    
    private func addTabBarController(){
        self.navigationController.pushViewController(self.tabBarController, animated: true)
    }
}
