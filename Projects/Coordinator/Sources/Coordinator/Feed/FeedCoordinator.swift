//
//  FeedCoordinator.swift
//  Coordinator
//
//  Created by 유현진 on 6/5/24.
//

import UIKit
import Presentation
class FeedCoordinator: Coordinator{
    
    var childCoordinator: [Coordinator] = []
    
    private var navigationController: UINavigationController!
    
    let feedDIContainer: FeedDIContainer
    
    init(navigationController: UINavigationController!) {
        self.navigationController = navigationController
        feedDIContainer = FeedDIContainer()
    }
    
    func start() {
        let vc = feedDIContainer.makeFeedViewController(coordinator: self)
        self.navigationController.pushViewController(vc, animated: true)
    }
}

extension FeedCoordinator: FeedCoordinatorInterface{
    func showFeedDetail(viewController: FeedViewController, postId: Int) {
        let vc = feedDIContainer.makeFeedDetailViewController(postId: postId, coordinator: self)
        vc.delegate = viewController
        self.navigationController.pushViewController(vc, animated: true)
    }
    
    func showReportComment(commentId: Int) {
        let vc = feedDIContainer.makeReportCommentViewController(commentId: commentId, coordinator: self)
        self.navigationController.pushViewController(vc, animated: true)
    }
    
    func showEditPost(viewController: FeedDetailViewController, postId: Int){
        let vc = feedDIContainer.makeEditPostViewController(postId: postId, coordinator: self)
        vc.delegate = viewController
        self.navigationController.pushViewController(vc, animated: true)
    }
}
