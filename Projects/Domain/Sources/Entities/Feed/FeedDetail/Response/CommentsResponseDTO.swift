//
//  CommentsResponseDTO.swift
//  Domain
//
//  Created by 유현진 on 6/12/24.
//

import Foundation

public struct CommentsResponseDTO: Decodable{
    let timeStamp: String
    let status: String
    let message: String
    public let data: CommentsResponseData
    
    enum CodingKeys: CodingKey {
        case timeStamp
        case status
        case message
        case data
    }
}

public struct CommentsResponseData: Decodable{
    public let content: [CommentModel]
    public let pageNumber: Int
    public let totalPages: Int
    
    enum CodingKeys: CodingKey {
        case content
        case pageNumber
        case totalPages
    }
}

public struct CommentModel: Decodable{
    public let commentId: Int
    public let nickName: String?
    public let userId: Int
    public let postId: Int
    public let content: String
    public let reportedCount: Int
    public let isDeleted: Bool
    public let createDate: String
    public let updateDate: String?
    public let owner: Bool
    //"parentReplyNo": null,
    //"children": [],
    
    enum CodingKeys: String, CodingKey {
        case commentId = "replyNo"
        case userId = "memberNo"
        case nickName = "memberName"
        case postId = "postNo"
        case content = "replyContent"
        case reportedCount
        case isDeleted = "deleted"
        case createDate
        case updateDate
        case owner
    }
}
