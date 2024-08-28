//
//  MyCoordinator.swift
//  Coordinator
//
//  Created by 유현진 on 6/6/24.
//

import UIKit
import Presentation
import Domain

class MyCoordinator: Coordinator{
    var childCoordinator: [Coordinator] = []
    
    private var parentCoordinator: Coordinator?
    
    private var navigationController: UINavigationController!
    let myDIContainer: MyDIContainer
    
    public init(parentCoordinator: Coordinator, navigationController: UINavigationController) {
        self.navigationController = navigationController
        self.myDIContainer = MyDIContainer()
        self.parentCoordinator = parentCoordinator
    }
    
    func start() {
        let vc = myDIContainer.makeMyViewController(coordinator: self)
        self.navigationController.pushViewController(vc, animated: true)
    }
}

extension MyCoordinator: MyCoordinatorInterface{
    func showNotice() {
        let vc = myDIContainer.makeNoticeViewController(coordinator: self)
        self.navigationController.pushViewController(vc, animated: true)
    }
    
    func showNoticeDetail(noticeModel: NoticeModel) {
        let vc = myDIContainer.makeNoticeDetailViewController(noticeModel: noticeModel)
        self.navigationController.pushViewController(vc, animated: true)
    }
    
    func showCustomerCenter() {
        let vc = myDIContainer.makeCustomerCenterViewController(coordinator: self)
        self.navigationController.pushViewController(vc, animated: true)
    }
    
    func showLevelHelp() {
        let vc = myDIContainer.makeLevelHelpViewController()
        self.navigationController.present(vc, animated: true)
    }
    
    func showAnnounce() {
        let vc = myDIContainer.makeAnnounceViewController()
        self.navigationController.pushViewController(vc, animated: true)
    }
    
    func showMyFeed() {
        let vc = myDIContainer.makeMyFeedViewController(coordinator: self)
        self.navigationController.pushViewController(vc, animated: true)
    }
    
    func showFeedDetailByMyFeed(viewController: MyFeedViewController, postId: Int) {
        let vc = myDIContainer.makeFeedDetailViewController(postId: postId)
        vc.delegate = viewController
        self.navigationController.pushViewController(vc, animated: true)
    }
    
    func showEditProfile(viewController: MyViewController) {
        let vc = myDIContainer.makeEditProfileViewController(coordinator: self)
        vc.delegate = viewController
        self.navigationController.pushViewController(vc, animated: true)
    }
    
    func showSignOut() {
        let vc = myDIContainer.makeSignOutViewController(coordinator: self)
        self.navigationController.pushViewController(vc, animated: true)
    }
    
    func backLogin() {
        guard let baseTabCoordinator = self.parentCoordinator as? BaseTabBarCoordinator else { return }
        baseTabCoordinator.delegate?.backLogin(coordinator: baseTabCoordinator)
    }
    
    func showMakeFeedback(viewController: CustomerCenterViewController) {
        let vc = myDIContainer.makeMakeFeedbackViewController(coordinator: self)
        vc.delegate = viewController
        self.navigationController.pushViewController(vc, animated: true)
    }
    
    func showFeedbackDetail(feedbackId: Int) {
        let vc = myDIContainer.makeFeedbackDetailViewController(feedbackId: feedbackId, coordinator: self)
        self.navigationController.pushViewController(vc, animated: true)
    }
}
