//
//  FeedModel.swift
//  Domain
//
//  Created by 유현진 on 8/22/24.
//

import Foundation

public struct FeedModel: Decodable{
    public let postId: Int
    public let nickname: String?
    public let createDate: String?
    public let postContent: String
    public let role: String
    public let profileImageUrl: String?
    public let mainData: String
    public let imageUrl: String?
    public let commentCount: Int
    public let likeCount: Int
    public var isBookmarked: Bool
    
    enum CodingKeys: String, CodingKey {
        case postId = "postNo"
        case nickname
        case createDate
        case postContent
        case role
        case profileImageUrl
        case mainData
        case imageUrl
        case commentCount = "replyCnt"
        case likeCount = "likeCnt"
        case isBookmarked
    }
}
