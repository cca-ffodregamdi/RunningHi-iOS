//
//  FeedDetailResponseDTO.swift
//  Domain
//
//  Created by 유현진 on 6/8/24.
//

import Foundation

public struct FeedDetailResponseDTO: Decodable{
    let timeStamp: String
    let status: String
    let message: String
    public let data: FeedDetailModel
    
    enum CodingKeys: CodingKey {
        case timeStamp
        case status
        case message
        case data
    }
}

public struct FeedDetailModel: Decodable{
    public let nickname: String?
    public let profileImagUrl: String?
    public let level: Int
    public let postContent: String
    public let role: String
    public let loactionName: String?
    public let distance: Float
    public let time: Float
    public let meanPace: Float
    public let kcal: Float
    public let imageUrls: [String?]
//    public let replyList:
    public let likeCount: Int
    enum CodingKeys: String, CodingKey {
        case nickname
        case profileImagUrl
        case level
        case postContent
        case role
        case loactionName
        case distance
        case time
        case meanPace
        case kcal
        case imageUrls
        case likeCount = "likeCnt"
    }
}
