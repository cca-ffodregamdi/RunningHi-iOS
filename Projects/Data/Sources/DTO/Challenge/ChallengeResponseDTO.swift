//
//  ChallengeResponseDTO.swift
//  Domain
//
//  Created by 유현진 on 5/29/24.
//

import Foundation
import Domain

public struct ChallengeResponseDTO: Decodable{
    let timeStamp: String
    let status: String
    let message: String
    let data: ChallengeModelDTO
}

public struct ChallengeModelDTO: Decodable{
    let challengeList: [ChallengeResponseModel]
}

public struct ChallengeResponseModel: Decodable{
    let challengeNo: Int
    let title: String?
    let imageUrl: String?
    let startDate: String?
    let endDate: String?
    let remainingTime: Int?
    let participantsCount: Int?
    
    func toEntity() -> ChallengeModel{
        return ChallengeModel(challengeId: challengeNo,
                              title: title ?? "",
                              imageUrl: imageUrl ?? "",
                              startDate: Date.formatDateStringToDate(dateString: startDate ?? "") ?? Date(),
                              endDate: Date.formatDateStringToDate(dateString: endDate ?? "") ?? Date(),
                              remainingTime: remainingTime ?? 0,
                              participantsCount: participantsCount ?? 0)
    }
}
