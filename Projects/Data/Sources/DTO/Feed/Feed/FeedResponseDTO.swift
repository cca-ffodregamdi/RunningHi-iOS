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
    public let content: [FeedModel]
    public let totalPages: Int
    
    enum CodingKeys: CodingKey {
        case content
        case totalPages
    }
}
