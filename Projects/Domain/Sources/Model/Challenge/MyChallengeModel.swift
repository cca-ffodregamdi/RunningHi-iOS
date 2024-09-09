//
//  MyChallengeModel.swift
//  Domain
//
//  Created by 유현진 on 8/15/24.
//

import Foundation

public struct MyChallengeModel{
    public let myChallengeId: Int
    public let challengeId: Int
    public let title: String
    public let imageUrl: String
    public let startDate: Date
    public let endDate: Date
    public let remainingTime: Int
    public let participantsCount: Int
    
    public init(myChallengeId: Int, challengeId: Int, title: String, imageUrl: String, startDate: Date, endDate: Date, remainingTime: Int, participantsCount: Int) {
        self.myChallengeId = myChallengeId
        self.challengeId = challengeId
        self.title = title
        self.imageUrl = imageUrl
        self.startDate = startDate
        self.endDate = endDate
        self.remainingTime = remainingTime
        self.participantsCount = participantsCount
    }
}
