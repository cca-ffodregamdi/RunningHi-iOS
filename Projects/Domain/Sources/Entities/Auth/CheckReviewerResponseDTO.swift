//
//  CheckReviewerResponseDTO.swift
//  Domain
//
//  Created by najin on 9/5/24.
//

import Foundation

public struct CheckReviewerResponseDTO: Decodable {
    let timeStamp: String
    let status: String
    let message: String
    public let data: ReviewerResponseDTO?
}

public struct ReviewerResponseDTO: Decodable {
    public let isReviewer: Bool?
    public let user: ReviewerUserDTO?
}

public struct ReviewerUserDTO: Decodable {
    public let memberNo: Int
    public let nickname: String?
    public let accessToken: String?
    public let refreshToken: String?
}
