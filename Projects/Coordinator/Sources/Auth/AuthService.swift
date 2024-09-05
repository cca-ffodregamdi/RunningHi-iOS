//
//  AuthService.swift
//  Coordinator
//
//  Created by 유현진 on 6/7/24.
//

import Foundation
import Moya
import Data

public enum AuthService{
    case isValidAccessToken
    case isValidRefreshToken
    case isReviewerVersion(String)
}

extension AuthService: TargetType{
    public var baseURL: URL {
        switch self {
        case .isValidAccessToken,
             .isValidRefreshToken :
            return .init(string: "https://runninghi.store/api/v1")!
        case .isReviewerVersion:
            return .init(string: "https://runninghi.store")!
        }
    }
    
    public var accessToken: String{
        return KeyChainManager.read(key: .runningHiAccessTokenkey) ?? ""
    }
    
    public var refreshToken: String{
        return KeyChainManager.read(key: .runningHiRefreshTokenKey) ?? ""
    }
    
    public var authorizationType: AuthorizationType{
        switch self{
        case .isValidAccessToken, .isValidRefreshToken, .isReviewerVersion:
                .bearer
        }
    }
    
    public var path: String {
        switch self{
        case .isValidAccessToken:
            return "/login/access-token/validate"
        case .isValidRefreshToken:
            return "/login/refresh-token/validate"
        case .isReviewerVersion:
            return "/test/app-review"
        }
    }
    
    public var method: Moya.Method {
        switch self{
        case .isValidAccessToken,
                .isValidRefreshToken:
            return .post
        case .isReviewerVersion:
            return .get
        }
    }
    
    public var task: Moya.Task {
        switch self{
        case .isValidAccessToken,
                .isValidRefreshToken:
            return .requestPlain
        case .isReviewerVersion(let version):
            return .requestParameters(parameters: ["ver" : version], encoding: URLEncoding.queryString)
        }
    }
    
    public var headers: [String : String]? {
        switch self{
        case .isValidAccessToken:
            return ["Content-type": "application/json",
                    "Authorization" : accessToken]
        case .isValidRefreshToken:
            return ["Content-type": "application/json",
                    "Authorization" : refreshToken]
        case .isReviewerVersion:
            return nil
        }
    }
}
