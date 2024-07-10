//
//  FeedLikeResponseDTO.swift
//  Domain
//
//  Created by 유현진 on 7/10/24.
//

import Foundation
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
    public let likeCount: Int
    
    enum CodingKeys: String, CodingKey{
        case likeCount = "likeCnt"
    }
}
