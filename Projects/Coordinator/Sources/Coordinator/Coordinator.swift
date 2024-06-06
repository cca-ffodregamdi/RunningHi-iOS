//
//  Coordinator.swift
//  Coordinator
//
//  Created by 유현진 on 6/5/24.
//

import Foundation

protocol Coordinator: AnyObject{
    var childCoordinator: [Coordinator] {get set}
    
    func start()
}
