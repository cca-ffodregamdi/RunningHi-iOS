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
    public let data: ChallengeModelDTO
}

public struct ChallengeModelDTO: Decodable{
    let challengeList: [ChallengeModel]
}
