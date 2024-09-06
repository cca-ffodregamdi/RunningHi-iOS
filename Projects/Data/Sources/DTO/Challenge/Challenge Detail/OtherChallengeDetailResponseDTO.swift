//
//  OtherChallengeDetailResponseDTO.swift
//  Data
//
//  Created by 유현진 on 9/6/24.
//

import Foundation
import Domain

public struct OtherChallengeDetailResponseDTO: Decodable{
    let timeStamp: String
    let status: String
    let message: String
    public let data: OtherChallengeDetailResponseModel
}

public struct OtherChallengeDetailResponseModel: Decodable{
    public let challengeNo: Int
    public let title: String?
    public let content: String?
    public let challengeCategory: String?
    public let imageUrl: String?
    public let goal: Float?
    public let goalDetail: String?
    public let startDate: String?
    public let endDate: String?
    public let participantsCount: Int?
    public let ranking: [RankResponseModel]?
    
    
    func toEntity() -> OtherChallengeDetailModel{
        return OtherChallengeDetailModel(challengeId: challengeNo,
                                         title: title ?? "",
                                         content: content ?? "",
                                         challengeCategory: ChallengeCategoryType(rawValue: challengeCategory ?? "") ?? .ATTENDANCE,
                                         imageUrl: imageUrl ?? "",
                                         goal: goal ?? 0.0,
                                         goalDetail: goalDetail ?? "",
                                         startDate: Date.formatDateStringToDate(dateString: startDate ?? "") ?? Date(),
                                         endDate: Date.formatDateStringToDate(dateString: endDate ?? "") ?? Date(),
                                         participantsCount: participantsCount ?? 0,
                                         ranking: ranking?.compactMap{$0.toEntity()} ?? [])
    }
    
}
