//
//  MyDIContainer.swift
//  Coordinator
//
//  Created by 유현진 on 6/6/24.
//

import Foundation
import Presentation
import Data
import Domain

class MyDIContainer{
    
    private lazy var myRepository: MyRepositoryImplementation = {
        return MyRepositoryImplementation()
    }()
    
    private lazy var myUsecase: MyUseCase = {
        return MyUseCase(repository: myRepository)
    }()
    
    func makeMyViewController(coordinator: MyCoordinator) -> MyViewController{
        let vc = MyViewController(reactor: MyReactor(myUseCase: myUsecase))
        vc.coordinator = coordinator
        return vc
    }
    
    func makeNoticeViewController(coordinator: MyCoordinator) -> NoticeViewController{
        let vc = NoticeViewController(reactor: NoticeReactor(myUseCase: myUsecase))
        vc.coordinator = coordinator
        return vc
    }
    
    func makeNoticeDetailViewController(noticeModel: NoticeModel) -> NoticeDetailViewController{
        let vc = NoticeDetailViewController(noticeModel: noticeModel)
        return vc
    }
    
    func makeCustomerCenterViewController(coordinator: MyCoordinator) -> CustomerCenterViewController{
        let vc = CustomerCenterViewController(reactor: CustomerCenterReactor(myUseCase: myUsecase))
        vc.coordinator = coordinator
        return vc
    }
    
    func makeLevelHelpViewController() -> LevelHelpViewController{
        let vc = LevelHelpViewController()
        return vc
    }
    
    func makeAnnounceViewController() -> AnnounceViewController{
        let vc = AnnounceViewController(reactor: AnnounceReactor(announceUseCase: AnnounceUseCase(repository: AnnounceRepositoryImplementation())))
        return vc
    }
    
    func makeMyFeedViewController(coordinator: MyCoordinator) -> MyFeedViewController{
        let vc = MyFeedViewController(reactor: MyFeedReactor(myUseCase: MyUseCase(repository: myRepository)))
        vc.coordinator = coordinator
        return vc
    }
    
    func makeFeedDetailViewController(postId: Int) -> FeedDetailViewController{
        let vc = FeedDetailViewController(reactor: FeedDetailReactor(feedUseCase: FeedUseCase(repository: FeedRepositoryImplementation()), postId: postId))
        return vc
    }
    
    func makeEditProfileViewController(coordinator: MyCoordinator) -> EditProfileViewController{
        let vc = EditProfileViewController(reactor: EditProfileReactor(myUseCase: myUsecase))
        vc.coordinator = coordinator
        return vc
    }
    
    func makeSignOutViewController(coordinator: MyCoordinator) -> SignOutViewController{
        let vc = SignOutViewController(reactor: SignOutReactor(myUseCase: myUsecase))
        vc.coordinator = coordinator
        return vc
    }
    func makeFeedbackDetailViewController(feedbackId: Int, coordinator: MyCoordinator) -> FeedbackDetailViewController{
        let vc = FeedbackDetailViewController(reactor: FeedbackDetailReactor(feedbackId: feedbackId, myUseCase: myUsecase))
        return vc
    }
}
