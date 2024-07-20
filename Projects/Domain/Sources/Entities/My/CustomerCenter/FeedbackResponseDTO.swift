//
//  FeedbackResponseDTO.swift
//  Domain
//
//  Created by 유현진 on 7/18/24.
//

import Foundation

public struct FeedbackResponseDTO: Decodable{
    let timeStamp: String
    let status: String
    let message: String
    public let data: FeedbackContentResponse
}

public struct FeedbackContentResponse: Decodable{
    public let content: [FeedbackModel]
}

public struct FeedbackModel: Decodable{
    public let feedbackId: Int
    public let title: String
    public let content: String
    public let category: FeedbackCategory
    public let createDate: String
    public let updateDate: String
    public let hasReply: Bool
    public let reply: String?
    public let nickName: String
    
    enum CodingKeys: String, CodingKey {
        case feedbackId = "feedbackNo"
        case title
        case content
        case category
        case createDate
        case updateDate
        case hasReply
        case reply
        case nickName = "nickname"
    }
}

public enum FeedbackCategory: String, Decodable{
    case INQUIRY
    case PROPOSAL
    case WEBERROR
    case ROUTEERROR
    case POSTERROR
}
