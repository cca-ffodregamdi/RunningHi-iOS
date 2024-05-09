//
//  TabBarCoordinator.swift
//  Presentation
//
//  Created by 유현진 on 5/9/24.
//

import UIKit

protocol TabBarCoordinator: Coordinator{
    var tabBarController: UITabBarController { get set }
}


enum TabBarItemType: String, CaseIterable{
    case Home, Collection, Course, Rank, My
    
    init?(index: Int){
        switch index{
        case 0: self = .Home
        case 1: self = .Collection
        case 2: self = .Course
        case 3: self = .Rank
        case 4: self = .My
        default: return nil
        }
    }
    
    func getNumber() -> Int{
        switch self{
        case .Home: return 0
        case .Collection: return 1
        case .Course: return 2
        case .Rank: return 3
        case .My: return 4
        }
    }
    
    func getTitle() -> String{
        switch self{
        case .Home: return "홈"
        case .Collection: return "저장"
        case .Course: return "코스 등록"
        case .Rank: return "순위"
        case .My: return "내 정보"
        }
    }
    
//    func getImage() -> Image{
//        switch self{
//        case .Home: return 
//        case .Collection: return
//        case .Course: return
//        case .Rank: return
//        case .My: return
//        }
//    }
}
