//
//  NoticeResponseDTO.swift
//  Domain
//
//  Created by 유현진 on 7/18/24.
//

import Foundation

public struct NoticeResponseDTO: Decodable{
    let timeStamp: String
    let status: String
    let message: String
    public let data: NoticeResponseData
}

public struct NoticeResponseData: Decodable{
    public let content: [NoticeModel]
}

public struct NoticeModel: Decodable{
    public let noticeId: Int
    public let title: String
    public let content: String
    public let createDate: String
    
    enum CodingKeys: String, CodingKey {
        case noticeId = "noticeNo"
        case title
        case content
        case createDate
    }
}
