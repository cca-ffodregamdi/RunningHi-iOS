//
//  TabBarDIContainer.swift
//  Coordinator
//
//  Created by najin on 7/2/24.
//

import Presentation
import Common
import Moya

class TabBarDIContainer {
    
    func makeTabBarController(coordinator: TabBarCoordinatorInterface) -> TabBarViewController {
        let vc = TabBarViewController()
        vc.coordinator = coordinator
        return vc
    }
    
    func makeRunningPopupViewController() -> RunningPopupViewController {
        let vc = RunningPopupViewController()
        return vc
    }
    
    func makeRunningViewController() -> RunningViewController {
        let vc = RunningViewController()
        return vc
    }
}

enum TabBarItemType: String, CaseIterable{
    case Feed, Challenge, Course, Record, My
    
    public init?(index: Int){
        switch index{
        case 0: self = .Feed
        case 1: self = .Challenge
        case 2: self = .Course
        case 3: self = .Record
        case 4: self = .My
        default: return nil
        }
    }
    
    func getNumber() -> Int{
        switch self{
        case .Feed: return 0
        case .Challenge: return 1
        case .Course: return 2
        case .Record: return 3
        case .My: return 4
        }
    }
    
    func getTitle() -> String{
        switch self{
        case .Feed: return "피드"
        case .Challenge: return "챌린지"
        case .Course: return ""
        case .Record: return "기록"
        case .My: return "마이페이지"
        }
    }
    
    func getImage() -> Image{
        switch self{
        case .Feed: return CommonAsset.homeOutline.image
        case .Challenge: return CommonAsset.fireOutline.image
        case .Course: return CommonAsset.plusCircle.image
        case .Record: return CommonAsset.chartBarOutline.image
        case .My: return CommonAsset.userOutline.image
        }
    }
}
