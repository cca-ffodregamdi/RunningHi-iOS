//
//  ReviewerUserModel.swift
//  Domain
//
//  Created by najin on 9/5/24.
//

import Foundation

public struct ReviewerUserModel {
    public let memberNo: Int
    public let nickname: String
    public let accessToken: String
    public let refreshToken: String
    
    public init(memberNo: Int, nickname: String, accessToken: String, refreshToken: String) {
        self.memberNo = memberNo
        self.nickname = nickname
        self.accessToken = accessToken
        self.refreshToken = refreshToken
    }
}
