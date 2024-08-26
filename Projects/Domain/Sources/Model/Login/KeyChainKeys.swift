//
//  KeyChainKeys.swift
//  Domain
//
//  Created by 유현진 on 8/15/24.
//

import Foundation

public enum KeyChainKeys: String, CaseIterable{
    case kakaoLoginAccessTokenKey = "kakaoLoginAccessToken"
    case appleLoginAuthorizationCodeKey = "appleLoginAuthorizationCode"
    case appleLoginIdentityTokenKey = "appleLoginIdentityToken"
    case runningHiAccessTokenkey = "runningHiAccessToken"
    case runningHiRefreshTokenKey = "runningHiRefreshToken"
}
