//
//  TabBarViewController.swift
//  Presentation
//
//  Created by najin on 7/2/24.
//

import UIKit
import RxSwift
import Common

final public class TabBarViewController: UITabBarController, UITabBarControllerDelegate {
    
    public var disposeBag: DisposeBag = DisposeBag()
    public var coordinator: TabBarCoordinatorInterface?
    
    var isActiveRunningTab = false
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        delegate = self
    }
    
    public func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        guard let vcIndex = tabBarController.viewControllers?.firstIndex(of: viewController) else { return false }
        
        if vcIndex == 2 {
            toggleCourseTabBar(isActive: !isActiveRunningTab)
            if isActiveRunningTab {
                coordinator?.showRunningPopup(viewController)
            }
            return false
        } else {
            if isActiveRunningTab {
                toggleCourseTabBar(isActive: !isActiveRunningTab)
            }
            guard let fromView = tabBarController.selectedViewController?.view,
                  let toView = viewController.view else { return false }
            if fromView == toView {
                return false
            } else {
                UIView.transition(from: fromView, to: toView, duration: 0.2, options: .transitionCrossDissolve)
                return true
            }
        }
    }

    func toggleCourseTabBar(isActive: Bool) {
        if let courseTabBarItem = self.viewControllers?[2].tabBarItem {
            isActiveRunningTab = isActive
            
            let image = isActive ? CommonAsset.xCircle.image : CommonAsset.plusCircle.image
            courseTabBarItem.image = image
            courseTabBarItem.selectedImage = image
        }
    }
}
