//
//  FeedDTO.swift
//  Domain
//
//  Created by 유현진 on 5/26/24.
//

import Foundation
import Domain

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
    public let content: [FeedResponseModel]
    public let totalPages: Int
    
    enum CodingKeys: CodingKey {
        case content
        case totalPages
    }
}

public struct FeedResponseModel: Decodable{
    public let postNo: Int
    public let nickname: String?
    public let createDate: String?
    public let postContent: String?
    public let role: String?
    public let profileImageUrl: String?
    public let mainData: String?
    public let imageUrl: String?
    public let replyCnt: Int?
    public let likeCnt: Int?
    public var isBookmarked: Bool?
    public let isWriter: Bool?
    func toEntity() -> FeedModel{
        return FeedModel(postId: postNo,
                         nickname: nickname ?? "",
                         createDate: Date.formatDateStringToDate(dateString: createDate ?? "") ?? Date(),
                         postContent: postContent ?? "",
                         role: role ?? "",
                         profileImageUrl: profileImageUrl,
                         mainData: mainData ?? "",
                         imageUrl: imageUrl,
                         commentCount: replyCnt ?? 0,
                         likeCount: likeCnt ?? 0,
                         isBookmarked: isBookmarked ?? false,
                         isWriter: isWriter ?? false)
    }
}
