//
//  OtherChallengeDetailResponseDTO.swift
//  Domain
//
//  Created by 유현진 on 7/4/24.
//

import Foundation

public struct OtherChallengeDetailResponseDTO: Decodable{
    let timeStamp: String
    let status: String
    let message: String
    public let data: OtherChallengeDetailModel
}

public struct OtherChallengeDetailModel: Decodable{
    public let challengeId: Int
    public let title: String
    public let content: String
    public let challengeCategory: String
    public let imageUrl: String
    public let goal: String
    public let startDate: String
    public let endDate: String
    public let participantsCount: Int
    public let ranking: [RankModel]
    
    enum CodingKeys: String, CodingKey {
        case challengeId = "challengeNo"
        case title
        case content
        case challengeCategory
        case imageUrl
        case goal
        case startDate
        case endDate
        case participantsCount
        case ranking
    }
}
