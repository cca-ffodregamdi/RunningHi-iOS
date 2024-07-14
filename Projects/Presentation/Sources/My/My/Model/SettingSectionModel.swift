//
//  SettingSectionModel.swift
//  Presentation
//
//  Created by 유현진 on 5/19/24.
//

import Foundation
import ReactorKit
import RxDataSources
import Moya
import Common

struct MyPageSection {
    var items: [MyPageItem]
}

public enum MyPageItem: Int, CaseIterable {
    case myFeed
    case notices
    case setting
    case customerCenter
    case logOut
    
    var title: String{
        switch self{
        case .myFeed: return "나의 피드"
        case .notices: return "공지사항"
        case .setting: return "설정"
        case .customerCenter: return "고객센터"
        case .logOut: return "로그아웃"
        }
    }
    
    var image: Image{
        switch self{
        case .setting: return CommonAsset.cogOutline.image
        case .notices: return CommonAsset.speakerphoneOutline.image
        case .myFeed: return CommonAsset.collectionOutline.image
        case .customerCenter: return CommonAsset.customerServiceOutline.image
        case .logOut: return CommonAsset.logoutOutline.image
        }
    }
}

extension MyPageSection: SectionModelType {
    typealias Item = MyPageItem

    init(original: MyPageSection, items: [MyPageItem]) {
        self = original
        self.items = items
    }
}
