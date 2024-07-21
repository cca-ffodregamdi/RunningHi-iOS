//
//  RecordDIContainer.swift
//  Coordinator
//
//  Created by najin on 7/21/24.
//

import Foundation
import Presentation
import Domain
import Data

class RecordDIContainer {
    private lazy var recordRepository: RecordRepositoryImplementation = {
        return RecordRepositoryImplementation()
    }()
    
    private lazy var recordUseCase: RecordUseCase = {
        return RecordUseCase(repository: recordRepository)
    }()
    
    func makeRecordViewController(coordinator: RecordCoordinator) -> RecordViewController {
        let vc = RecordViewController(reactor: RecordReactor(recordUseCase: recordUseCase))
        vc.coordinator = coordinator
        return vc
    }
    
    func makeRecordDetailViewController(coordinator: RecordCoordinator) -> RecordDetailViewController{
        let vc = RecordDetailViewController(reactor: RecordReactor(recordUseCase: recordUseCase))
        vc.coordinator = coordinator
        return vc
    }
}
