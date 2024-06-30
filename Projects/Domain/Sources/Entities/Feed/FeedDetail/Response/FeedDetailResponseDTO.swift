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
    public let profileImageUrl: String?
    public let level: Int
    public let postContent: String
    public let role: String
    public let loactionName: String?
    public let distance: Float
    public let time: Int
    public let meanPace: Int
    public let kcal: Int
    public let imageUrl: String?
    public let createDate: String
    public var commentCount: Int
    public var likeCount: Int
    public let isOwner: Bool
    
    enum CodingKeys: String, CodingKey {
        case nickname
        case profileImageUrl
        case level
        case postContent
        case role
        case loactionName
        case distance
        case time
        case meanPace
        case kcal
        case imageUrl
        case createDate
        case likeCount = "likeCnt"
        case commentCount = "replyCnt"
        case isOwner = "owner"
    }
}
