//
//  CheckReviewerResponseDTO.swift
//  Data
//
//  Created by 유현진 on 9/10/24.
//

import Foundation
import Domain

public struct CheckReviewerResponseDTO: Decodable {
    let timeStamp: String
    let status: String
    let message: String
    public let data: ReviewerResponseDTO?
}

public struct ReviewerResponseDTO: Decodable {
    public let isReviewer: Bool?
    public let user: ReviewerUserResponseModel?
}

public struct ReviewerUserResponseModel: Decodable {
    public let memberNo: Int
    public let nickname: String?
    public let accessToken: String?
    public let refreshToken: String?
    
    func toEntity() -> ReviewerUserModel{
        return ReviewerUserModel(memberNo: memberNo,
                                 nickname: nickname ?? "",
                                 accessToken: accessToken ?? "",
                                 refreshToken: refreshToken ?? "")
    }
}
