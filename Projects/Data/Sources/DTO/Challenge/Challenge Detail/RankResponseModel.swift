//
//  RankResponseModel.swift
//  Data
//
//  Created by 유현진 on 9/6/24.
//

import Foundation
import Domain

public struct RankResponseModel: Decodable{
    public let profileUrl: String?
    public let rank: Int?
    public let nickname: String?
    public let record: Float?
    public let memberChallengeId: Int
    
    
    func toEntity() -> RankModel{
        return RankModel(profileImageUrl: profileUrl,
                         rank: rank ?? 0,
                         nickname: nickname ?? "",
                         record: record ?? 0.0,
                         myChallengeId: memberChallengeId)
    }
}
