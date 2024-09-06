//
//  FeedbackDetailResponseDTO.swift
//  Data
//
//  Created by 유현진 on 8/27/24.
//

import Foundation
import Domain

public struct FeedbackDetailResponseDTO: Decodable{
    let timeStamp: String
    let status: String
    let message: String
    public let data: FeedbackDetailResponseModel
}

public struct FeedbackDetailResponseModel: Decodable{
    let feedbackNo: Int
    let title: String?
    let content: String?
    let category: String?
    let createDate: String?
    let updateDate: String?
    let hasReply: Bool?
    let reply: String?
    let nickname: String?

    
    func toEntity() -> FeedbackDetailModel{
        return FeedbackDetailModel(feedbackId: feedbackNo,
                                   title: title ?? "",
                                   content: content ?? "",
                                   category: FeedbackCategory(rawValue: category ?? "") ?? .INQUIRY,
                                   createData: Date.formatDateStringToDate(dateString: createDate ?? "") ?? Date(),
                                   updateDate: Date.formatDateStringToDate(dateString: updateDate ?? "") ?? Date(),
                                   hasReply: hasReply ?? false,
                                   reply: reply,
                                   nickname: nickname ?? "")
    }
}
