//
//  SignOutReasonCase.swift
//  Presentation
//
//  Created by 유현진 on 8/24/24.
//

import Foundation

enum SignOutReasonCase{
    case unusable
    case manyAnnounce
    case difficult
    case doNotRun
    case lowMethod
    case etc
    
    var title: String{
        switch self{
        case .unusable: "자주 사용하지 않아요."
        case .manyAnnounce: "알림이 많이 와요."
        case .difficult: "앱 사용이 어려워요."
        case .doNotRun: "더이상 달리지 않아요."
        case .lowMethod: "기능이 부족해요."
        case .etc: "기타"
        }
    }
}
