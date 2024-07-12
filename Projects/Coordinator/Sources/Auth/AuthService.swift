//
//  AuthService.swift
//  Coordinator
//
//  Created by 유현진 on 6/7/24.
//

import Foundation
import Moya

public enum AuthService{
    case isValidAccessToken
    case isValidRefreshToken
}

extension AuthService: TargetType{
    public var baseURL: URL {
        return .init(string: "https://runninghi.store/api/v1")!
    }
    
    public var accessToken: String{
        return UserDefaults.standard.object(forKey: "accessToken") as? String ?? ""
    }
    
    public var refreshToken: String{
        return UserDefaults.standard.object(forKey: "refreshToken") as? String ?? ""
    }
    
    public var authorizationType: AuthorizationType{
        switch self{
        case .isValidAccessToken, .isValidRefreshToken:
                .bearer
        }
    }
    
    public var path: String {
        switch self{
        case .isValidAccessToken:
            return "/login/access-token/validate"
        case .isValidRefreshToken:
            return "/login/refresh-token/validate"
        }
    }
    
    public var method: Moya.Method {
        switch self{
        case .isValidAccessToken,
                .isValidRefreshToken:
            return .post
            
        }
    }
    
    public var task: Moya.Task {
        switch self{
        case .isValidAccessToken,
                .isValidRefreshToken:
            return .requestPlain
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
        }
    }
}
