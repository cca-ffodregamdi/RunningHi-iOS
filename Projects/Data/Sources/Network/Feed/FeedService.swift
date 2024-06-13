//
//  FeedService.swift
//  Data
//
//  Created by 유현진 on 5/26/24.
//

import Foundation
import Moya
import RxSwift
import Domain

public enum FeedService{
    case fetchFeeds(page: Int)
    case fetchPost(postId: Int)
    case fetchComment(postId: Int)
    case writeComment(commentModel: WriteCommentReqesutDTO)
    case makeBookmark(post: BookmarkRequestDTO)
    case deleteBookmark(postId: Int)
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
        case .fetchComment(let postId):
            return "/reply/\(postId)"
        case .writeComment:
            return "/reply"
        case .makeBookmark:
            return "/bookmark"
        case .deleteBookmark(let postId):
            return "/bookmark/\(postId)"
        }
    }
    
    public var method: Moya.Method {
        switch self{
        case .fetchFeeds,
                .fetchPost,
                .fetchComment:
            return .get
        case .writeComment,
            .makeBookmark:
            return .post
        case .deleteBookmark:
            return .delete
        }
    }
    
    public var task: Moya.Task {
        switch self{
        case .fetchFeeds(let page):
            return .requestParameters(parameters: ["page" : page], encoding: URLEncoding.queryString)
        case .fetchPost,
                .fetchComment,
                .deleteBookmark:
            return .requestPlain
        case .writeComment(let commentModel):
            return .requestJSONEncodable(commentModel)
        case .makeBookmark(let postModel):
            return .requestJSONEncodable(postModel)
        }
    }
    
    public var headers: [String : String]? {
        switch self{
        case .fetchFeeds,
                .fetchPost,
                .fetchComment,
                .writeComment,
                .makeBookmark,
                .deleteBookmark:
            return ["Content-type": "application/json",
                    "Authorization": accessToken]
        
        }
    }
}
