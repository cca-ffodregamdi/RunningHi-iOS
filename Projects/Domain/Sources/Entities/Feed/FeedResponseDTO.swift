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
    
    public init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.timeStamp = try container.decode(String.self, forKey: .timeStamp)
        self.status = try container.decode(String.self, forKey: .status)
        self.message = try container.decode(String.self, forKey: .message)
        self.data = try container.decode(FeedResponseData.self, forKey: .data)
    }
}

public struct FeedResponseData: Decodable{
    public let content: [FeedModel]
}

public struct FeedModel: Decodable{
    public let postNo: Int
    public let nickname: String
    public let postTitle: String
    public let postContent: String
    public let role: String
    public let locationName: String
}
