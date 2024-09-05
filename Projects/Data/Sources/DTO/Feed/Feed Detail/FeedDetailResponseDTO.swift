//
//  FeedDetailResponseDTO.swift
//  Data
//
//  Created by 유현진 on 8/30/24.
//

import Foundation
import Domain

public struct FeedDetailResponseDTO: Decodable{
    let timeStamp: String
    let status: String
    let message: String
    public let data: FeedDetailResponseModel
    
    enum CodingKeys: CodingKey {
        case timeStamp
        case status
        case message
        case data
    }
}

public struct FeedDetailResponseModel: Decodable{
    public let nickname: String?
    public let profileImageUrl: String?
    public let level: Int?
    public let postContent: String?
    public let role: String?
    public let locationName: String?
    public let distance: Float?
    public let time: Int?
    public let meanPace: Int?
    public let kcal: Int?
    public let imageUrl: String?
    public let createDate: String?
    public let replyCnt: Int?
    public let likeCnt: Int?
    public let owner: Bool?
    public let isLiked: Bool?
    public let isBookmarked: Bool?
    public let difficulty: String?
    public let gpsUrl: String?
    
    func toEntity() -> FeedDetailModel{
        return FeedDetailModel(nickname: nickname ?? "",
                               profileImageUrl: profileImageUrl,
                               level: level ?? 0,
                               postContent: postContent ?? "",
                               role: role ?? "",
                               locationName: locationName ?? "",
                               distance: distance ?? 0.0,
                               time: time ?? 0,
                               meanPace: meanPace ?? 0,
                               kcal: kcal ?? 0,
                               imageUrl: imageUrl,
                               createDate: Date.formatDateStringToDate(dateString: createDate ?? "") ?? Date(),
                               commentCount: replyCnt ?? 0,
                               likeCount: likeCnt ?? 0,
                               isOwner: owner ?? false,
                               isLiked: isLiked ?? false,
                               isBookmarked: isBookmarked ?? false,
                               difficulty: FeedDetailDifficultyType(rawValue: difficulty ?? "") ?? .EASY)
    }
}

