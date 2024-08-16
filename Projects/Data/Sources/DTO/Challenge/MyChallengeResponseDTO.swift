//
//  MyChallengeResponseDTO.swift
//  Domain
//
//  Created by 유현진 on 7/4/24.
//

import Foundation
import Domain

public struct MyChallengeResponseDTO: Decodable{
    let timeStamp: String
    let status: String
    let message: String
    let data: MyChallengeModelDTO
}

public struct MyChallengeModelDTO: Decodable{
    let myChallengeList: [MyChallengeModel]
}
