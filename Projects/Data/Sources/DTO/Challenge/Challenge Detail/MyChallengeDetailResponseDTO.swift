//
//  MyChallengeDetailResponseDTO.swift
//  Data
//
//  Created by 유현진 on 9/6/24.
//

import Foundation
import Domain

public struct MyChallengeDetailResponseDTO: Decodable{
    let timeStamp: String
    let status: String
    let message: String
    public let data: MyChallengeDetailResponseModel
}

public struct MyChallengeDetailResponseModel: Decodable{
    public let challengeNo: Int
    public let memberChallengeId: Int
    public let title: String?
    public let content: String?
    public let challengeCategory: String?
    public let imageUrl: String?
    public let goal: Float?
    public let goalDetail: String?
    public let startDate: String?
    public let endDate: String?
    public let record: Float?
    public let participantsCount: Int?
    public let challengeRanking: [RankResponseModel]?
    public let memberRanking: RankResponseModel
    
    func toEntity() -> MyChallengeDetailModel{
        return  MyChallengeDetailModel(challengeId: challengeNo,
                                       myChallengeId: memberChallengeId,
                                       title: title ?? "",
                                       content: content ?? "",
                                       challengeCategory: ChallengeCategoryType(rawValue: challengeCategory ?? "") ?? .SPEED,
                                       imageUrl: imageUrl ?? "",
                                       goal: goal ?? 0.0,
                                       goalDetail: goalDetail ?? "",
                                       startDate: Date.formatDateStringToDate(dateString: startDate ?? "") ?? Date(),
                                       endDate: Date.formatDateStringToDate(dateString: endDate ?? "") ?? Date(),
                                       record: record ?? 0.0,
                                       participantsCount: participantsCount ?? 0,
                                       challengeRanking: challengeRanking?.compactMap{$0.toEntity()} ?? [] ,
                                       myRanking: memberRanking.toEntity())
    }
}
