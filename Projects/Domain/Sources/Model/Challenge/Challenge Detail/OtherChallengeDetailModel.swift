//
//  OtherChallengeDetailModel.swift
//  Domain
//
//  Created by 유현진 on 7/4/24.
//

import Foundation

public struct OtherChallengeDetailModel{
    public let challengeId: Int
    public let title: String
    public let content: String
    public let challengeCategory: ChallengeCategoryType
    public let imageUrl: String
    public let goal: Float
    public let goalDetail: String
    public let startDate: Date
    public let endDate: Date
    public let participantsCount: Int
    public let ranking: [RankModel]

    public init(challengeId: Int, title: String, content: String, challengeCategory: ChallengeCategoryType, imageUrl: String, goal: Float, goalDetail: String, startDate: Date, endDate: Date, participantsCount: Int, ranking: [RankModel]) {
        self.challengeId = challengeId
        self.title = title
        self.content = content
        self.challengeCategory = challengeCategory
        self.imageUrl = imageUrl
        self.goal = goal
        self.goalDetail = goalDetail
        self.startDate = startDate
        self.endDate = endDate
        self.participantsCount = participantsCount
        self.ranking = ranking
    }
}
