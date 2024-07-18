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
}
