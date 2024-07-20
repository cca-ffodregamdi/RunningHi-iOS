//
//  CustomerCenterSection.swift
//  Presentation
//
//  Created by 유현진 on 7/20/24.
//

import Foundation
import Domain
import RxDataSources

public enum CustomerCenterItemType{
    case faq(FAQModel)
    case feedback(FeedbackModel)
}

//extension CustomerCenterItemType: IdentifiableType, Equatable{
//    public var identity: String {
//        switch self{
//        case .faq(let faq):
//            return String(faq.identity)
//        case .feedback(let feedback):
//            return String(feedback.identity)
//        }
//    }
//    
//    public static func == (lhs: CustomerCenterItemType, rhs: CustomerCenterItemType) -> Bool {
//        switch (lhs, rhs) {
//        case (.faq(let lhsFaq), .faq(let rhsFaq)):
//            return lhsFaq == rhsFaq
//        case (.feedback(let lhsFeedback), .feedback(let rhsFeedback)):
//            return lhsFeedback == rhsFeedback
//        default:
//            return false
//        }
//    }
//}

public struct CustomerCenterSectionModel{
    var header: String
    public var items: [CustomerCenterItemType]
}
//extension CustomerCenterSectionModel: IdentifiableType, Equatable{
//    public var identity: String{
//        return header
//    }
//    
//    public static func == (lhs: CustomerCenterSectionModel, rhs: CustomerCenterSectionModel) -> Bool {
//        return lhs.header == rhs.header && lhs.items == rhs.items
//    }
//}

extension CustomerCenterSectionModel: SectionModelType{
    public typealias Item = CustomerCenterItemType
    public init(original: CustomerCenterSectionModel, items: [Item]) {
        self = original
        self.items = items
    }
}

//extension FAQModel: IdentifiableType, Equatable{
//    public var identity: Int {
//        return faqId
//    }
//    public static func == (lhs: FAQModel, rhs: FAQModel) -> Bool {
//        return lhs.faqId == rhs.faqId
//    }
//}
//
//extension FeedbackModel: IdentifiableType, Equatable{
//    public var identity: Int {
//        return feedbackId
//    }
//    
//    public static func == (lhs: FeedbackModel, rhs: FeedbackModel) -> Bool {
//        return lhs.feedbackId == rhs.feedbackId
//    }
//}
