//
//  FeedCoordinator.swift
//  Coordinator
//
//  Created by 유현진 on 6/5/24.
//

import UIKit
import Presentation
import Domain

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
        let vc = feedDIContainer.makeEditPostViewController(postId: postId, coordinator: self, enterType: .feed, isPosted: true)
        vc.delegate = viewController
        self.navigationController.pushViewController(vc, animated: true)
    }
    
    func showEditComment(viewController: FeedDetailViewController, commentModel: CommentModel) {
        let vc = feedDIContainer.makeEditCommentViewController(commentModel: commentModel)
        vc.delegate = viewController
        self.navigationController.pushViewController(vc, animated: true)
    }
    
    func showBookmarkedFeed(viewController: FeedViewController) {
        let vc = feedDIContainer.makeFeedWithOptionViewController(coordinator: self, feedOption: .bookmark)
        vc.delegate = viewController
        self.navigationController.pushViewController(vc, animated: true)
    }
    
    func showFeedDetailByBookmarkedFeed(viewController: FeedWithOptionViewController, postId: Int) {
        let vc = feedDIContainer.makeFeedDetailViewController(postId: postId, coordinator: self)
        vc.delegate = viewController
        self.navigationController.pushViewController(vc, animated: true)
    }
    
    func showDistanceFilter(viewController: FeedViewController, distanceState: DistanceFilter) {
        let vc = feedDIContainer.makeDistanceFilterViewController(distanceState: distanceState)
        vc.distanceFilterDelegate = viewController
        self.navigationController.present(vc, animated: true)
    }
    
    func showSortFilter(viewController: FeedViewController, sortState: SortFilter){
        let vc = feedDIContainer.makeSortFilterViewController(sortState: sortState)
        vc.sortFilterDelegate = viewController
        self.navigationController.present(vc, animated: true)
    }
    
    func showAnnounce() {
        let vc = feedDIContainer.showAnnounceViewController()
        self.navigationController.pushViewController(vc, animated: true)
    }
}
