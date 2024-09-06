//
//  FeedbackResponseDTO.swift
//  Domain
//
//  Created by 유현진 on 7/18/24.
//

import Foundation
import Domain

public struct FeedbackResponseDTO: Decodable{
    let timeStamp: String
    let status: String
    let message: String
    public let data: FeedbackContentResponse
}

public struct FeedbackContentResponse: Decodable{
    public let content: [FeedbackReseponseModel]
    
    
}

public struct FeedbackReseponseModel: Decodable{
    public let feedbackId: Int
    public let title: String
    public let content: String
    public let category: String
    public let createDate: String
    public let updateDate: String?
    public let hasReply: Bool
    public let reply: String?
    public let nickname: String
    
    enum CodingKeys: String, CodingKey {
        case feedbackId = "feedbackNo"
        case title
        case content
        case category
        case createDate
        case updateDate
        case hasReply
        case reply
        case nickname
    }
    
    func toEntity() -> FeedbackModel{
        return FeedbackModel(feedbackId: feedbackId,
                             title: title,
                             content: content,
                             category: FeedbackCategory.init(rawValue: category) ?? FeedbackCategory.INQUIRY,
                             createDate: Date.formatDateStringToDate(dateString: createDate) ?? Date(),
                             updateDate: Date.formatDateStringToDate(dateString: updateDate ?? "") ?? Date(),
                             hasReply: hasReply,
                             reply: reply,
                             nickname: nickname)
    }
}
