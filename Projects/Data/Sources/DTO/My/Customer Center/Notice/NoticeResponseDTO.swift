//
//  NoticeResponseDTO.swift
//  Data
//
//  Created by 유현진 on 9/6/24.
//

import Foundation
import Domain

public struct NoticeResponseDTO: Decodable{
    let timeStamp: String
    let status: String
    let message: String
    public let data: NoticeResponseData
}

public struct NoticeResponseData: Decodable{
    public let content: [NoticeResponseModel]
}

public struct NoticeResponseModel: Decodable{
    public let noticeNo: Int
    public let title: String?
    public let content: String?
    public let createDate: String?
    
    func toEntity() -> NoticeModel{
        return NoticeModel(noticeId: noticeNo,
                           title: title ?? "",
                           content: content ?? "",
                           createDate: Date.formatDateStringToDate(dateString: createDate ?? "") ?? Date())
    }
}
