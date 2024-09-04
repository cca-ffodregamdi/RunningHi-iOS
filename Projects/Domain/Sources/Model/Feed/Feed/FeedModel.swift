//
//  FeedModel.swift
//  Domain
//
//  Created by 유현진 on 8/22/24.
//

import Foundation

public struct FeedModel: Decodable{
    public let postId: Int
    public let nickname: String
    public let createDate: Date
    public let postContent: String
    public let role: String
    public let profileImageUrl: String?
    public let mainData: String
    public let imageUrl: String?
    public let commentCount: Int
    public let likeCount: Int
    public var isBookmarked: Bool
    public let isWriter: Bool
    
    public init(postId: Int, nickname: String, createDate: Date, postContent: String, role: String, profileImageUrl: String?, mainData: String, imageUrl: String?, commentCount: Int, likeCount: Int, isBookmarked: Bool, isWriter: Bool) {
        self.postId = postId
        self.nickname = nickname
        self.createDate = createDate
        self.postContent = postContent
        self.role = role
        self.profileImageUrl = profileImageUrl
        self.mainData = mainData
        self.imageUrl = imageUrl
        self.commentCount = commentCount
        self.likeCount = likeCount
        self.isBookmarked = isBookmarked
        self.isWriter = isWriter
    }
}
