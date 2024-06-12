//
//  CommentResponseDTO.swift
//  Domain
//
//  Created by 유현진 on 6/12/24.
//

import Foundation

public struct CommentResponseDTO: Decodable{
    let timeStamp: String
    let status: String
    let message: String
    public let data: [CommentModel]
    
    enum CodingKeys: CodingKey {
        case timeStamp
        case status
        case message
        case data
    }
}

public struct CommentModel: Decodable{
    public let replyNo: Int
    public let nickName: String?
    public let postId: Int
    public let content: String
    public let reportedCount: Int
    public let isDeleted: Bool
    public let createDate: String
    public let updateDate: String?
    
    //"parentReplyNo": null,
    //"children": [],
    
    enum CodingKeys: String, CodingKey {
        case replyNo
        case nickName = "memberName"
        case postId = "postNo"
        case content = "replyContent"
        case reportedCount
        case isDeleted
        case createDate
        case updateDate
    }
}
