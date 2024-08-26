//
//  MyUserInfoModel.swift
//  Domain
//
//  Created by 유현진 on 8/19/24.
//

import Foundation

public struct MyUserInfoModel: Decodable{
    public let userId: Int
    public let nickname: String
    public let level: Int
    public let totalDistance: Double
    public let distanceToNextLevel: Int
    public let totalKcal: Double
    public let profileImageUrl: String
    
    enum CodingKeys: String, CodingKey {
        case userId = "memberNo"
        case nickname
        case level
        case totalDistance
        case distanceToNextLevel
        case totalKcal
        case profileImageUrl
    }
}
