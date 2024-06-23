//
//  ReportCommentSectionModel.swift
//  Presentation
//
//  Created by 유현진 on 6/21/24.
//

import Foundation
import RxDataSources

public struct ReportCommentSection{
    public var items: [ReportCommentType]
}

extension ReportCommentSection: SectionModelType{
    public typealias Item = ReportCommentType
    
    public init(original: ReportCommentSection, items: [ReportCommentType]) {
        self = original
        self.items = items
    }
    
    
}

public enum ReportCommentType: Int, CaseIterable{
    case spam
    case illegal
    case adultContent
    case abuse
    case privacy
    case other
    
    var title: String{
        switch self{
        case .spam: "광고, 도배, 스팸"
        case .illegal: "불법 정보"
        case .adultContent: "음란, 청소년 유해"
        case .abuse: "욕설, 비방, 차별, 혐오"
        case .privacy: "개인 정보 노출, 유포, 거래"
        case .other: "기타"
        }
    }
    
    var category: String{
        switch self{
        case .spam: return "SPAM"
        case .illegal: return "ILLEGAL"
        case .adultContent: return "ADULT_CONTENT"
        case .abuse: return "ABUSE"
        case .privacy: return "PRIVACY"
        case .other: return "OTHER"
        }
    }
}
