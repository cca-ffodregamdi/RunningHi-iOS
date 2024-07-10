//
//  MyChallengeDetailResponseDTO.swift
//  Domain
//
//  Created by 유현진 on 7/4/24.
//

import Foundation

public struct MyChallengeDetailResponseDTO: Decodable{
    let timeStamp: String
    let status: String
    let message: String
    public let data: MyChallengeDetailModel
}

public struct MyChallengeDetailModel: Decodable{
    public let challengeId: Int
    public let myChallengeId: Int
    public let title: String
    public let content: String
    public let challengeCategory: String
    public let imageUrl: String
    public let goal: Float
    public let startDate: String
    public let endDate: String
    public let record: Float
    public let participantsCount: Int
    public let challengeRanking: [RankModel]
    public let myRanking: RankModel
    
    enum CodingKeys: String, CodingKey {
        case challengeId = "challengeNo"
        case myChallengeId = "memberChallengeId"
        case title
        case content
        case challengeCategory
        case imageUrl
        case goal
        case startDate
        case endDate
        case record
        case participantsCount
        case challengeRanking
        case myRanking = "memberRanking"
    }
}
