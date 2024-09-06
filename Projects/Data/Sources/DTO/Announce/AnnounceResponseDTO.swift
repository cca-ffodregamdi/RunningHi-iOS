//
//  AnnounceResponseDTO.swift
//  Domain
//
//  Created by 유현진 on 8/5/24.
//

import Foundation
import Domain

public struct AnnounceResponseDTO: Decodable{
    let timeStamp: String
    let status: String
    let message: String
    public let data: [AnnounceResponseModel]
}

public struct AnnounceResponseModel: Decodable{
    public let title: String?
    public let alarmId: Int
    public let isRead: Bool?
    public let createDate: String?
    
    func toEntity() -> AnnounceModel{
        return AnnounceModel(title: title ?? "",
                             announceId: alarmId,
                             isRead: isRead ?? false,
                             createDate: Date.formatDateStringToDate(dateString: createDate ?? "") ?? Date())
    }
}
