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

extension MyPageSection: SectionModelType {
    typealias Item = MyPageItem

    init(original: MyPageSection, items: [MyPageItem]) {
        self = original
        self.items = items
    }
}

public enum MyPageItem: Int, CaseIterable {
    case myFeed
    case notices
    case noticeSetting
    case customerCenter
    case locationSetting
    
    
    var title: String{
        switch self{
        case .myFeed: return "나의 피드"
        case .notices: return "공지사항"
        case .noticeSetting: return "알림 설정"
        case .customerCenter: return "고객센터"
        case .locationSetting: return "우리동네 지역 설정"
        }
    }
    
    var image: Image{
        switch self{
        case .noticeSetting: return CommonAsset.cogOutline.image
        case .notices: return CommonAsset.speakerphoneOutline.image
        case .myFeed: return CommonAsset.collectionOutline.image
        case .customerCenter: return CommonAsset.customerServiceOutline.image
        case .locationSetting: return CommonAsset.locationMarkerOutline.image
        }
    }
}
