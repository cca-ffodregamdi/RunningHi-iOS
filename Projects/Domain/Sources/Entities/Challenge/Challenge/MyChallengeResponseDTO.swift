//
//  MyChallengeResponseDTO.swift
//  Domain
//
//  Created by 유현진 on 7/4/24.
//

import Foundation

public struct MyChallengeResponseDTO: Decodable{
    let timeStamp: String
    let status: String
    let message: String
    public let data: [MyChallengeModel]
}

public struct MyChallengeModel: Decodable{
    public let myChallengeId: Int
    public let challengeId: Int
    public let title: String
    public let imageUrl: String
    let startDate: String
    let endDate: String
    public let remainingTime: Int
    public let participantsCount: Int
    
    enum CodingKeys: String, CodingKey {
        case myChallengeId = "memberChallengeId"
        case challengeId
        case title
        case imageUrl
        case startDate
        case endDate
        case remainingTime
        case participantsCount
    }
}
