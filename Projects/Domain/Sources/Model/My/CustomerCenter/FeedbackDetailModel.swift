//
//  FeedbackDetailModel.swift
//  Domain
//
//  Created by 유현진 on 8/27/24.
//

import Foundation

//    "feedbackNo": 31,
    //        "title": "피드백 수정할래요",
    //        "content": "피드백 수정~",
    //        "category": "POSTERROR",
    //        "createDate": "2024-05-06T15:07:12",
    //        "updateDate": "2024-05-06T15:33:13",
    //        "hasReply": true,
    //        "reply": "피드백/문의사항에 대한 답변 내용을 여기에 넣어주세요~",
    //        "nickname": "고구마맛있다"

public struct FeedbackDetailModel: Decodable{
    public let feedbackId: Int
    public let title: String
    public let content: String
    public let category: FeedbackCategory
    public let createData: Date
    public let updateDate: Date
    public let hasReply: Bool
    public let reply: String?
    public let nickname: String
    
    public init(feedbackId: Int, title: String, content: String, category: FeedbackCategory, createData: Date, updateDate: Date, hasReply: Bool, reply: String?, nickname: String) {
        self.feedbackId = feedbackId
        self.title = title
        self.content = content
        self.category = category
        self.createData = createData
        self.updateDate = updateDate
        self.hasReply = hasReply
        self.reply = reply
        self.nickname = nickname
    }
}
