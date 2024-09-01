//
//  RecordCoordinator.swift
//  Coordinator
//
//  Created by najin on 7/21/24.
//

import UIKit
import Presentation
import Domain

class RecordCoordinator: Coordinator {
    
    var childCoordinator: [Coordinator] = []
    
    private var navigationController: UINavigationController!
    
    let recordDIContainer: RecordDIContainer
    
    init(navigationController: UINavigationController!) {
        self.navigationController = navigationController
        recordDIContainer = RecordDIContainer()
    }
    
    func start() {
        let vc = recordDIContainer.makeRecordViewController(coordinator: self)
        self.navigationController.pushViewController(vc, animated: true)
    }
}

extension RecordCoordinator: RecordCoordinatorInterface {
    func showRecordDetail(postNo: Int, isPosted: Bool) {
        let vc = recordDIContainer.makeRecordDetailViewController(coordinator: self, postNo: postNo, isPosted: isPosted)
        self.navigationController.pushViewController(vc, animated: true)
    }
    
    func showEditFeed(postNo: Int, isPosted: Bool) {
        let feedCoordinator: FeedCoordinator = FeedCoordinator(navigationController: navigationController)
        let feedDIContainer = feedCoordinator.feedDIContainer
        
        let vc = feedDIContainer.makeEditPostViewController(postId: postNo, coordinator: feedCoordinator, enterType: .record, isPosted: isPosted)
        self.navigationController.pushViewController(vc, animated: true)
    }
}

