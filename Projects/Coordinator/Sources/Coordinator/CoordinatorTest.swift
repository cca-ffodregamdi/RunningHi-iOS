//
//  CoordinatorTest.swift
//  Coordinator
//
//  Created by 유현진 on 6/5/24.
//

import Foundation

protocol CoordinatorTest: AnyObject{
    var childCoordinator: [CoordinatorTest] {get set}
    
    func start()
}
