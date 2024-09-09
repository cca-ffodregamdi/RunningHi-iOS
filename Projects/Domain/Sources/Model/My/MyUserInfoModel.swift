//
//  MyUserInfoModel.swift
//  Domain
//
//  Created by 유현진 on 8/19/24.
//

import Foundation

public struct MyUserInfoModel{
    public let userId: Int
    public let nickname: String
    public let level: Int
    public let totalDistance: Double
    public let distanceToNextLevel: Double
    public let totalKcal: Double
    public let profileImageUrl: String?
    
    public init(userId: Int, nickname: String, level: Int, totalDistance: Double, distanceToNextLevel: Double, totalKcal: Double, profileImageUrl: String?) {
        self.userId = userId
        self.nickname = nickname
        self.level = level
        self.totalDistance = totalDistance
        self.distanceToNextLevel = distanceToNextLevel
        self.totalKcal = totalKcal
        self.profileImageUrl = profileImageUrl
    }
}
