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
    let myChallengeList: [MyChallengeResponseModel]
}

public struct MyChallengeResponseModel: Decodable{
    let memberChallengeId: Int
    let challengeId: Int
    let title: String?
    let imageUrl: String?
    let startDate: String?
    let endDate: String?
    let remainingTime: Int?
    let participantsCount: Int?
    
    func toEntity() -> MyChallengeModel{
        return MyChallengeModel(myChallengeId: memberChallengeId,
                                challengeId: challengeId,
                                title: title ?? "",
                                imageUrl: imageUrl ?? "",
                                startDate: Date.formatDateStringToDate(dateString: startDate ?? "") ?? Date(),
                                endDate: Date.formatDateStringToDate(dateString: endDate ?? "") ?? Date(),
                                remainingTime: remainingTime ?? 0,
                                participantsCount: participantsCount ?? 0)
    }
}
