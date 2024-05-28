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
        return .init(string: "https://runninghi.store/api/v1")!
        
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
                    "Authorization": "Bearer eyJhbGciOiJIUzUxMiJ9.eyJzdWIiOiI0Iiwicm9sZSI6IlVTRVIiLCJpc3MiOiJydW5uaW5naGktdjIuY29tIiwiaWF0IjoxNzE2ODA5NTUyLCJleHAiOjE3MjE5OTM1NTJ9.LSKLVrypmTsS5gVerFZUnTVfbwST9_-xDOpO_0i_KxzKl8se6AoAdyr85VQztRuB_khbEbpWEDatd_yK1r2vUA"]
                    
        }
    }
}
