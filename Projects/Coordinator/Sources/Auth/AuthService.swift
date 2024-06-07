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

//public enum FeedService{
//    case fetchFeeds(page: Int, size: Int, keyword: [String] = [])
//}
//
//extension FeedService: TargetType{
//    public var baseURL: URL {
//        return .init(string: "https://runninghi.store/api/v1")!
//
//    }
//
//    public var accessToken: String{
//        return UserDefaults.standard.object(forKey: "accessToken") as! String
//    }
//
//    public var path: String {
//        switch self{
//        case .fetchFeeds:
//            return "/posts"
//        }
//    }
//
//    public var method: Moya.Method {
//        switch self{
//        case .fetchFeeds:
//            return .get
//        }
//    }
//
//    public var task: Moya.Task {
//        switch self{
//        case let .fetchFeeds(page, size, keyword):
//            return .requestParameters(parameters: ["page" : page, "size": size, "keyword": keyword], encoding: URLEncoding.queryString)
//        }
//    }
//
//    public var headers: [String : String]? {
//        switch self{
//        case .fetchFeeds:
//            return ["Content-type": "application/json",
//                    "Authorization": "Bearer eyJhbGciOiJIUzUxMiJ9.eyJzdWIiOiIzIiwicm9sZSI6IkFETUlOIiwiaXNzIjoicnVubmluZ2hpLXYyLmNvbSIsImlhdCI6MTcxNzY3NjY0MywiZXhwIjoxNzIyODYwNjQzfQ.COT-FPDUOTk5J8auZe770_hl34IF1vcD1KXtcVoDBK7Gv1cX4RqX724hHnFgyU8QBwUKYopH_D2X72ngFYCg9w"]
//
//        }
//    }
//}

