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
    
    
    func makeMyViewController(coordinator: MyCoordinator) -> MyViewController{
        let vc = MyViewController()
        vc.coordinator = coordinator
        return vc
    }
}
