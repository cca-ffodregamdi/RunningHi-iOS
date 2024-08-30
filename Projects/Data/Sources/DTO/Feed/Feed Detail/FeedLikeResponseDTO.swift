//
//  FeedLikeResponseDTO.swift
//  Data
//
//  Created by 유현진 on 8/30/24.
//

import Foundation
import Domain

public struct FeedLikeResponseDTO: Decodable{
    let timeStamp: String
    let status: String
    let message: String
    public let data: FeedLikeResponseModel
    
    enum CodingKeys: CodingKey {
        case timeStamp
        case status
        case message
        case data
    }
}

public struct FeedLikeResponseModel: Decodable{
    public let likeCnt: Int?
    
    
    func toEntity() -> FeedLikeModel{
        return FeedLikeModel(likeCount: likeCnt ?? 0)
    }
}
