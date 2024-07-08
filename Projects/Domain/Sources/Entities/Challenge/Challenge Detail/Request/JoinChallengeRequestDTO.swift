//
//  JoinChallengeRequestDTO.swift
//  Domain
//
//  Created by 유현진 on 7/8/24.
//

import Foundation

public struct JoinChallengeRequestDTO: Codable{
    var challengeNo: Int
    
    public init(challengeId: Int) {
        self.challengeNo = challengeId
    }
}
