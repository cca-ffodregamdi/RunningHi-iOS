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
    public let title: String
    public let imageUrl: String
    let stateDate: String
    let endDate: String
    public let remainingTime: Int
    public let participantsCount: Int
    
    enum CodingKeys: String, CodingKey {
        case myChallengeId = "memberChallengeId"
        case title
        case imageUrl
        case stateDate
        case endDate
        case remainingTime = "RemainingTime"
        case participantsCount
    }
}
