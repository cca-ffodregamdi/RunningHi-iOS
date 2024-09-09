//
//  MyUserInfoDTO.swift
//  Data
//
//  Created by 유현진 on 8/19/24.
//

import Foundation
import Domain

public struct MyUserInfoDTO: Decodable{
    let timeStamp: String
    let status: String
    let message: String
    public let data: MyUserInfoResponseModel
}


public struct MyUserInfoResponseModel: Decodable{
    public let memberNo: Int
    public let nickname: String?
    public let level: Int?
    public let totalDistance: Double?
    public let distanceToNextLevel: Double?
    public let totalKcal: Double?
    public let profileImageUrl: String?
    
    func toEntity() -> MyUserInfoModel{
        return MyUserInfoModel(userId: memberNo,
                               nickname: nickname ?? "",
                               level: level ?? 0,
                               totalDistance: totalDistance ?? 0.0,
                               distanceToNextLevel: distanceToNextLevel ?? 0.0,
                               totalKcal: totalKcal ?? 0.0,
                               profileImageUrl: profileImageUrl)
    }
}
