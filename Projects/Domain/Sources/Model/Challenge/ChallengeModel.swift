//
//  ChallengeModel.swift
//  Domain
//
//  Created by 유현진 on 8/15/24.
//

import Foundation

public struct ChallengeModel{
    public let challengeId: Int
    public let title: String
    public let imageUrl: String
    public let startDate: Date
    public let endDate: Date
    public let remainingTime: Int
    public let participantsCount: Int
    
    public init(challengeId: Int, title: String, imageUrl: String, startDate: Date, endDate: Date, remainingTime: Int, participantsCount: Int) {
        self.challengeId = challengeId
        self.title = title
        self.imageUrl = imageUrl
        self.startDate = startDate
        self.endDate = endDate
        self.remainingTime = remainingTime
        self.participantsCount = participantsCount
    }
}
