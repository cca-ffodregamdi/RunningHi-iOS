//
//  FeedDIContainer.swift
//  Coordinator
//
//  Created by 유현진 on 6/5/24.
//

import Foundation
import Presentation
import Data
import Domain

class FeedDIContainer{
    private lazy var feedRepository: FeedRepositoryImplementation = {
        return FeedRepositoryImplementation()
    }()
    
    private lazy var feedUseCase: FeedUseCase = {
        return FeedUseCase(repository: feedRepository)
    }()
    
    func makeFeedViewController(coordinator: FeedCoordinator) -> FeedViewController{
        let feedUseCase = feedUseCase
        let vc = FeedViewController(reactor: FeedReactor(feedUseCase: feedUseCase))
        vc.coordinator = coordinator
        return vc
    }
    
    func makeFeedDetailViewController(postId: Int, coordinator: FeedCoordinator) -> FeedDetailViewController{
        let feedUseCase = feedUseCase
        let vc = FeedDetailViewController(reactor: FeedDetailReactor(feedUseCase: feedUseCase, postId: postId))
        vc.coordinator = coordinator
        return vc
    }
    
    func makeReportCommentViewController(commentId: Int, coordinator: FeedCoordinator) -> ReportCommentViewController{
        let feedUseCase = feedUseCase
        let vc = ReportCommentViewController(reactor: ReportCommentReactor(feedUsecase: feedUseCase, commentId: commentId))
        return vc
    }
    
    func makeEditPostViewController(postId: Int, coordinator: FeedCoordinator) -> EditFeedViewController{
        let feedUseCase = feedUseCase
        let vc = EditFeedViewController(reactor: EditFeedReactor(feedUseCase: feedUseCase), postNo: postId)
        return vc
    }
    
    func makeEditCommentViewController(commentModel: CommentModel) -> EditCommentViewController{
        let feedUseCase = feedUseCase
        let vc = EditCommentViewController(reactor: EditCommentReactor(feedUseCase: feedUseCase, commentModel: commentModel))
        return vc
    }
    
    func makeBookmarkedFeedViewController(coordinator: FeedCoordinator) -> BookmarkedFeedViewController{
        let vc = BookmarkedFeedViewController(reactor: BookmarkedReactor(feedUseCase: feedUseCase))
        vc.coordinator = coordinator
        return vc
    }
    
    func makeDistanceFilterViewController(distanceState: DistanceFilter) -> DistanceFilterViewController{
        let vc = DistanceFilterViewController(distanceState: distanceState)
        return vc
    }
    
    func makeSortFilterViewController(sortState: SortFilter) -> SortFilterViewController{
        let vc = SortFilterViewController(sortState: sortState)
        return vc
    }
    
    func showAnnounceViewController() -> AnnounceViewController{
        let vc = AnnounceViewController(reactor: AnnounceReactor(announceUseCase: AnnounceUseCase(repository: AnnounceRepositoryImplementation())))
        return vc
    }
}
