//
//  CommentModel.swift
//  Domain
//
//  Created by 유현진 on 6/12/24.
//

import Foundation

public struct CommentModel: Decodable{
    public let commentId: Int
    public let nickname: String
    public let userId: Int
    public let postId: Int
    public let content: String
    public let reportedCount: Int
    public let isDeleted: Bool
    public let profileUrl: String?
    public let createDate: Date
    public let isUpdated: Bool
    public let isOwner: Bool
    
    public init(commentId: Int, nickname: String, userId: Int, postId: Int, content: String, reportedCount: Int, isDeleted: Bool, profileUrl: String?, createDate: Date, isUpdated: Bool, isOwner: Bool) {
        self.commentId = commentId
        self.nickname = nickname
        self.userId = userId
        self.postId = postId
        self.content = content
        self.reportedCount = reportedCount
        self.isDeleted = isDeleted
        self.profileUrl = profileUrl
        self.createDate = createDate
        self.isUpdated = isUpdated
        self.isOwner = isOwner
    }
}
