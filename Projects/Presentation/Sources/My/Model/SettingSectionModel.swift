//
//  SettingSectionModel.swift
//  Presentation
//
//  Created by 유현진 on 5/19/24.
//

import Foundation
import ReactorKit
import RxDataSources

struct MyPageSection {
    var items: [MyPageItem]
}

public enum MyPageItem: Int, CaseIterable {
    case myFeed
    case notices
    case feedback
    
    var title: String{
        switch self{
        case .notices: return "공지사항"
        case .myFeed: return "내가 쓴 글"
        case .feedback: return "피드백 작성"
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
