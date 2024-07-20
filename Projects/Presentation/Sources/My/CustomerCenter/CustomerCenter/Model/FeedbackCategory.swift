//
//  FeedbackCategory.swift
//  Presentation
//
//  Created by 유현진 on 7/20/24.
//

import Foundation
import Domain

extension FeedbackCategory{
    var title: String{
        switch self{
        case .INQUIRY: "문의 사항"
        case .PROPOSAL: "개선 사항"
        case .WEBERROR: "웹페이지 오류"
        case .ROUTEERROR: "경로 오류"
        case .POSTERROR: "게시글 내용 오류"
        }
    }
}
