//
//  FeedbackModel.swift
//  Domain
//
//  Created by 유현진 on 8/26/24.
//

import Foundation

public struct FeedbackModel: Decodable{
    public let feedbackId: Int
    public let title: String
    public let content: String
    public let category: FeedbackCategory
    public let createDate: Date
    public let updateDate: Date
    public let hasReply: Bool
    public let reply: String?
    public let nickname: String
    
    public init(feedbackId: Int, title: String, content: String, category: FeedbackCategory, createDate: Date, updateDate: Date, hasReply: Bool, reply: String?, nickname: String) {
        self.feedbackId = feedbackId
        self.title = title
        self.content = content
        self.category = category
        self.createDate = createDate
        self.updateDate = updateDate
        self.hasReply = hasReply
        self.reply = reply
        self.nickname = nickname
    }
}

public enum FeedbackCategory: String, Decodable, CaseIterable{
    case INQUIRY
    case PROPOSAL
    case WEBERROR
    case ROUTEERROR
    case POSTERROR
}
