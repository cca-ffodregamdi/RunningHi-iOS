//
//  FeedService.swift
//  Data
//
//  Created by 유현진 on 5/26/24.
//

import Foundation
import Moya
import RxSwift

public enum FeedService{
    case fetchFeeds(page: Int)
    case fetchPost(postId: Int)
}

extension FeedService: TargetType{
    public var baseURL: URL {
        return .init(string: "https://runninghi.store/api/v1")!
        
    }
    
    public var accessToken: String{
        return UserDefaults.standard.object(forKey: "accessToken") as! String
    }
    
    public var path: String {
        switch self{
        case .fetchFeeds:
            return "/posts"
        case .fetchPost(let postId):
            return "/posts/\(postId)"
        }
    }
    
    public var method: Moya.Method {
        switch self{
        case .fetchFeeds,
                .fetchPost:
            return .get
        }
    }
    
    public var task: Moya.Task {
        switch self{
        case .fetchFeeds(let page):
            return .requestParameters(parameters: ["page" : page], encoding: URLEncoding.queryString)
        case .fetchPost:
            return .requestPlain
        }
    }
    
    public var headers: [String : String]? {
        switch self{
        case .fetchFeeds,
                .fetchPost:
            return ["Content-type": "application/json",
                    "Authorization": "Bearer eyJhbGciOiJIUzUxMiJ9.eyJzdWIiOiIzIiwicm9sZSI6IkFETUlOIiwiaXNzIjoicnVubmluZ2hpLXYyLmNvbSIsImlhdCI6MTcxNzY3NjY0MywiZXhwIjoxNzIyODYwNjQzfQ.COT-FPDUOTk5J8auZe770_hl34IF1vcD1KXtcVoDBK7Gv1cX4RqX724hHnFgyU8QBwUKYopH_D2X72ngFYCg9w"]
        
        }
    }
}
