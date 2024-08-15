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
    public let data: MyChallengeModelDTO
}

public struct MyChallengeModelDTO: Decodable{
    let myChallengeList: [MyChallengeModel]
}
