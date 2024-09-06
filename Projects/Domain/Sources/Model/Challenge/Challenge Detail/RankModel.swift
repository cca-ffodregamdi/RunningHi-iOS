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
    public let nickname: String
    public let record: Float
    public let myChallengeId: Int
    
    public init(profileImageUrl: String?, rank: Int, nickname: String, record: Float, myChallengeId: Int) {
        self.profileImageUrl = profileImageUrl
        self.rank = rank
        self.nickname = nickname
        self.record = record
        self.myChallengeId = myChallengeId
    }
}
