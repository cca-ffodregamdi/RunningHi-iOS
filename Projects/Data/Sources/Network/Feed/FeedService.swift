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
    case fetchFeeds(page: Int, size: Int, keyword: [String] = [])
}

extension FeedService: TargetType{
    public var baseURL: URL {
        return .init(string: "http://ec2-43-200-142-9.ap-northeast-2.compute.amazonaws.com:8080/api/v1")!
        
    }
    
    public var accessToken: String{
        return UserDefaults.standard.object(forKey: "accessToken") as! String
    }
    
    public var path: String {
        switch self{
        case .fetchFeeds:
            return "/posts"
        }
    }
    
    public var method: Moya.Method {
        switch self{
        case .fetchFeeds:
            return .get
        }
    }
    
    public var task: Moya.Task {
        switch self{
        case let .fetchFeeds(page, size, keyword):
            return .requestParameters(parameters: ["page" : page, "size": size, "keyword": keyword], encoding: URLEncoding.queryString)
        }
    }
    
    public var headers: [String : String]? {
        switch self{
        case .fetchFeeds:
            return ["Content-type": "application/json",
                    "Authorization": "Bearer " + accessToken]
                    
        }
    }
}
