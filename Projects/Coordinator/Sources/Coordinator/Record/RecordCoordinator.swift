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
    func showRecordDetail(postNo: Int) {
        let vc = recordDIContainer.makeRecordDetailViewController(coordinator: self, postNo: postNo)
        self.navigationController.pushViewController(vc, animated: true)
    }
}

