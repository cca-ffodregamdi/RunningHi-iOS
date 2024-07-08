//
//  RankModel.swift
//  Domain
//
//  Created by 유현진 on 6/2/24.
//

import Foundation

public struct RankModel: Decodable{
    public let profileImageUrl: String?
    public let rank: Int
    public let nickName: String
    public let record: String
    let myChallengeId: Int
    
    enum CodingKeys: String, CodingKey {
        case profileImageUrl = "profileUrl"
        case rank
        case nickName = "nickname"
        case record
        case myChallengeId = "memberChallengeId"
    }
}
