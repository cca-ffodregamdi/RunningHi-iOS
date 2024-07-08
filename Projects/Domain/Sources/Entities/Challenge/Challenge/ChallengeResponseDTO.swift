//
//  ChallengeResponseDTO.swift
//  Domain
//
//  Created by 유현진 on 5/29/24.
//

import Foundation

public struct ChallengeResponseDTO: Decodable{
    let timeStamp: String
    let status: String
    let message: String
    public let data: [ChallengeModel]
}

public struct ChallengeModel: Decodable{
    public let challengeId: Int
    public let title: String
    public let imageUrl: String
    let startDate: String
    let endDate: String
    public let remainingTime: Int
    public let participantsCount: Int
    
    enum CodingKeys: String, CodingKey {
        case challengeId = "challengeNo"
        case title
        case imageUrl
        case startDate
        case endDate
        case remainingTime
        case participantsCount
    }
}
