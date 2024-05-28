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
    
    enum CodingKeys: CodingKey {
        case content
    }
}

public struct FeedModel: Decodable{
    public let postNo: Int
    public let nickname: String?
    public let createDate: String
    public let postContent: String
    public let role: String
    public let locationName: String
    
    enum CodingKeys: CodingKey {
        case postNo
        case nickname
        case createDate
        case postContent
        case role
        case locationName
    }
}
