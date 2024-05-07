//
//  Coordinator.swift
//  Presentation
//
//  Created by 유현진 on 5/3/24.
//

import UIKit

protocol Coordinator: AnyObject{
    var childCoordinator: [Coordinator] {get set}
    
    func start()
}
