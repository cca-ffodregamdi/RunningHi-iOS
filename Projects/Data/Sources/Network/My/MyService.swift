//
//  MyService.swift
//  Data
//
//  Created by 유현진 on 7/15/24.
//

import Foundation
import Moya
import RxSwift
import Domain

public enum MyService{
    case fetchNotice
    case fetchFAQ
    case fetchFeedback
    case fetchUserInfo
    
    case fetchMyFeed(page: Int, size: Int)
    case makeBookmark(post: BookmarkRequestDTO)
    case deleteBookmark(postId: Int)
}

extension MyService: TargetType{
    public var baseURL: URL {
        return .init(string: "https://runninghi.store/api/v1")!
    }
    
    public var accessToken: String{
        return KeyChainManager.read(key: .runningHiAccessTokenkey)!
    }
    
    public var path: String{
        switch self{
        case .fetchNotice: "/notices"
        case .fetchFAQ: "/faq"
        case .fetchFeedback: "/feedbacks"
        case .fetchUserInfo: "/members"
        case .fetchMyFeed: "/posts/my-feed"
        case .makeBookmark: "/bookmark"
        case .deleteBookmark(let postId): "/bookmark/\(postId)"
        }
    }
    
    public var method: Moya.Method{
        switch self{
        case .fetchNotice, .fetchFAQ, .fetchFeedback, .fetchUserInfo, .fetchMyFeed: .get
        case .makeBookmark: .post
        case .deleteBookmark: .delete
        }
    }
    
    public var task: Task{
        switch self{
        case .fetchNotice, .fetchFAQ, .fetchFeedback, .fetchUserInfo, .deleteBookmark: .requestPlain
        case .fetchMyFeed(let page, let size): .requestParameters(parameters: ["page" : page + 1, "size" : size], encoding: URLEncoding.queryString)
        case .makeBookmark(let postModel): .requestJSONEncodable(postModel)
            
        }
    }
    
    public var headers: [String : String]?{
        switch self{
        case .fetchNotice, .fetchFAQ, .fetchFeedback, .fetchUserInfo, .fetchMyFeed, .makeBookmark, .deleteBookmark:
            ["Content-type": "application/json",
                    "Authorization": accessToken]
        }
    }
}
