//
//  MyChallengeDetailModel.swift
//  Domain
//
//  Created by 유현진 on 7/4/24.
//

import Foundation

public struct MyChallengeDetailModel{
    public let challengeId: Int
    public let myChallengeId: Int
    public let title: String
    public let content: String
    public let challengeCategory: ChallengeCategoryType
    public let imageUrl: String
    public let goal: Float
    public let goalDetail: String
    public let startDate: Date
    public let endDate: Date
    public let record: Float
    public let participantsCount: Int
    public let challengeRanking: [RankModel]
    public let myRanking: RankModel
    
    public init(challengeId: Int, myChallengeId: Int, title: String, content: String, challengeCategory: ChallengeCategoryType, imageUrl: String, goal: Float, goalDetail: String, startDate: Date, endDate: Date, record: Float, participantsCount: Int, challengeRanking: [RankModel], myRanking: RankModel) {
        self.challengeId = challengeId
        self.myChallengeId = myChallengeId
        self.title = title
        self.content = content
        self.challengeCategory = challengeCategory
        self.imageUrl = imageUrl
        self.goal = goal
        self.goalDetail = goalDetail
        self.startDate = startDate
        self.endDate = endDate
        self.record = record
        self.participantsCount = participantsCount
        self.challengeRanking = challengeRanking
        self.myRanking = myRanking
    }
}
