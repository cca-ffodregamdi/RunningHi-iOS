//
//  AnnounceModel.swift
//  Domain
//
//  Created by 유현진 on 8/20/24.
//

import Foundation

public struct AnnounceModel: Decodable{
    public let title: String
    public let announceId: Int
//    public let alarmType: String
//    public let targetPage: String
//    public let targetId: Int
    public let isRead: Bool
    public let createDate: String
    
    enum CodingKeys: String, CodingKey {
        case title
        case announceId = "alarmId"
        case isRead
        case createDate
    }
}
