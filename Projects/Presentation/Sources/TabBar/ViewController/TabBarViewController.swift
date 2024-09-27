//
//  TabBarViewController.swift
//  Presentation
//
//  Created by najin on 7/2/24.
//

import UIKit
import RxSwift
import Common
import UserNotifications
import ReactorKit
import RxCocoa

final public class TabBarViewController: UITabBarController, UITabBarControllerDelegate {
    
    public var disposeBag: DisposeBag = DisposeBag()
    public var coordinator: TabBarCoordinatorInterface?
    
    var isActiveRunningTab = false
    
    public init(reactor: TabBarReactor){
        super.init(nibName: nil, bundle: nil)
        self.reactor = reactor
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        delegate = self
    }
    
    public override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setPushNotification()
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
    
    func setPushNotification(){
        let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound] // 필요한 알림 권한을 설정
        UNUserNotificationCenter.current().requestAuthorization(
            options: authOptions,
            completionHandler: { granted, _ in
                if granted{
                    DispatchQueue.main.async {
                        UIApplication.shared.registerForRemoteNotifications()
                    }
                }
            }
        )
    }
}

extension TabBarViewController: View{
    public func bind(reactor: TabBarReactor) {
        NotificationCenter.default.rx
            .notification(Notification.Name("FCMToken"))
            .subscribe(onNext: { [weak self] notification in
                if let userInfo = notification.userInfo,
                   let token = userInfo["token"] as? String {
                    print("token -> \(token)")
                    reactor.action.onNext(.uploadFCMToken(token))
                }
            })
            .disposed(by: disposeBag)
        
    }
}
