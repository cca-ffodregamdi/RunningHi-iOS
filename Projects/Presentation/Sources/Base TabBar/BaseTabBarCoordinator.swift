//
//  BaseTabBarCoordinator.swift
//  Presentation
//
//  Created by 유현진 on 5/9/24.
//

import UIKit
import Common

class BaseTabBarCoordinator: TabBarCoordinator{
    var tabBarController: UITabBarController
    
    var childCoordinator: [Coordinator] = []
    
    private var navigationController: UINavigationController!
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
        self.tabBarController = UITabBarController()
    }
    
    func start() {
        let pages: [TabBarItemType] = TabBarItemType.allCases
        let tabBarItems: [UITabBarItem] = pages.map{ self.createTabBarItem(type: $0) }
        let controllers: [UINavigationController] = tabBarItems.map{
            self.createTabNavigationController(tabBarItem: $0)
        }
        controllers.forEach{self.startTabCoordinator(tabNavigationController: $0)}
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
            let homeCoordinator: HomeCoordinator = HomeCoordinator(navigationController: tabNavigationController)
            self.childCoordinator.append(homeCoordinator)
            homeCoordinator.start()
        case .Challenge:
            return
        case .Course:
            let courseCoordinator: RunningCourseCoordinator = RunningCourseCoordinator(navigationController: tabNavigationController)
            self.childCoordinator.append(courseCoordinator)
            courseCoordinator.start()
        case .Rank:
            return
        case .My:
            let myCoordinator: MyCoordinator = MyCoordinator(navigationController: tabNavigationController)
            self.childCoordinator.append(myCoordinator)
            myCoordinator.start()
            tabNavigationController.viewControllers.first?.title = TabBarItemType.My.getTitle()
        }
    }
    
    private func configureTabBarController(tabNavigationController: [UIViewController]){
        self.tabBarController.setViewControllers(tabNavigationController, animated: false)
        self.tabBarController.selectedIndex = TabBarItemType.Feed.getNumber()
        self.tabBarController.view.backgroundColor = .systemBackground
        self.tabBarController.tabBar.backgroundColor = .systemBackground
        self.tabBarController.tabBar.tintColor = .black
        
    }
    
    private func addTabBarController(){
        self.navigationController.pushViewController(self.tabBarController, animated: true)
    }
}
