//
//  FeedDTO.swift
//  Domain
//
//  Created by 유현진 on 5/26/24.
//

import Foundation

public struct FeedResponseDTO: Decodable{
    let timeStamp: String
    let status: String
    let message: String
    public let data: FeedResponseData
    
    public enum CodingKeys: CodingKey {
        case timeStamp
        case status
        case message
        case data
    }
}

public struct FeedResponseData: Decodable{
    public let content: [FeedModel]
    public let totalPages: Int
    enum CodingKeys: CodingKey {
        case content
        case totalPages
    }
}

public struct FeedModel: Decodable{
    public let postNo: Int
    public let nickname: String?
    public let createDate: String?
    public let postContent: String
    public let role: String
    public let profileImageUrl: String?
    public let kcal: Float
    public let imageUrl: String?
    public let bookmarkCount: Int
    public let likeCount: Int
    
    enum CodingKeys: String, CodingKey {
        case postNo
        case nickname
        case createDate
        case postContent
        case role
        case profileImageUrl
        case kcal
        case imageUrl
        case bookmarkCount = "bookmarkCnt"
        case likeCount = "likeCnt"  
    }
}
