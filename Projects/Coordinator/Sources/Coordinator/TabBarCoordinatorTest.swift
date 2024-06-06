//
//  TabBarCoordinatorTest.swift
//  Coordinator
//
//  Created by 유현진 on 6/5/24.
//

import UIKit
import Common
import Moya

protocol TabBarCoordinatorTest: CoordinatorTest{
    var tabBarController: UITabBarController { get set }
}


enum TabBarItemTypeTest: String, CaseIterable{
    case Feed, Challenge, Course, Rank, My
    
    public init?(index: Int){
        switch index{
        case 0: self = .Feed
        case 1: self = .Challenge
        case 2: self = .Course
        case 3: self = .Rank
        case 4: self = .My
        default: return nil
        }
    }
    
    func getNumber() -> Int{
        switch self{
        case .Feed: return 0
        case .Challenge: return 1
        case .Course: return 2
        case .Rank: return 3
        case .My: return 4
        }
    }
    
    func getTitle() -> String{
        switch self{
        case .Feed: return "피드"
        case .Challenge: return "챌린지"
        case .Course: return ""
        case .Rank: return "기록"
        case .My: return "마이페이지"
        }
    }
    
    func getImage() -> Image{
        switch self{
        case .Feed: return CommonAsset.homeOutline.image
        case .Challenge: return CommonAsset.fireOutline.image
        case .Course: return CommonAsset.plusCircle.image
        case .Rank: return CommonAsset.chartBarOutline.image
        case .My: return CommonAsset.userOutline.image
        }
    }
}
