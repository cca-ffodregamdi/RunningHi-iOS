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
}
