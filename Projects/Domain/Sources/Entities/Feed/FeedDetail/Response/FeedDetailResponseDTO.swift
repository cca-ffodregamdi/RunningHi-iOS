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

public struct FeedDetailModel: Decodable, Equatable{
    public let nickname: String?
    public let profileImageUrl: String?
    public let level: Int
    public let postContent: String
    public let role: String
    public let locationName: String
    public let distance: Float
    public let time: Int
    public let meanPace: Int
    public let kcal: Int
    public let imageUrl: String?
    public let createDate: String
    public var commentCount: Int
    public var likeCount: Int
    public let isOwner: Bool
    public var isLiked: Bool
    
    enum CodingKeys: String, CodingKey {
        case nickname
        case profileImageUrl
        case level
        case postContent
        case role
        case locationName
        case distance
        case time
        case meanPace
        case kcal
        case imageUrl
        case createDate
        case likeCount = "likeCnt"
        case commentCount = "replyCnt"
        case isOwner = "owner"
        case isLiked
    }
    
    public static func == (lhs: FeedDetailModel, rhs: FeedDetailModel) -> Bool {
          return lhs.nickname == rhs.nickname &&
                 lhs.profileImageUrl == rhs.profileImageUrl &&
                 lhs.level == rhs.level &&
                 lhs.postContent == rhs.postContent &&
                 lhs.role == rhs.role &&
                 lhs.locationName == rhs.locationName &&
                 lhs.distance == rhs.distance &&
                 lhs.time == rhs.time &&
                 lhs.meanPace == rhs.meanPace &&
                 lhs.kcal == rhs.kcal &&
                 lhs.imageUrl == rhs.imageUrl &&
                 lhs.createDate == rhs.createDate &&
                 lhs.commentCount == rhs.commentCount &&
                 lhs.likeCount == rhs.likeCount &&
                 lhs.isOwner == rhs.isOwner &&
                 lhs.isLiked == rhs.isLiked
      }
    
}
