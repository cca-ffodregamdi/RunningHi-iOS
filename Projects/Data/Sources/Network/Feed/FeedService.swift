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
    case fetchFeeds(page: Int, size: Int = 10)
    case fetchPost(postId: Int)
    case fetchComment(postId: Int)
    case writeComment(commentModel: WriteCommentReqesutDTO)
    case makeBookmark(post: BookmarkRequestDTO)
    case deleteBookmark(postId: Int)
    case deleteComment(postId: Int)
    case reportComment(reportCommentModel: ReportCommentRequestDTO)
    case deletePost(postId: Int)
    case editPost(postId: Int, editPostModel: EditFeedRequestDTO)
    case likePost(likePost: FeedLikeRequestDTO)
    case unLikePost(postId: Int)
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
        case .fetchComment:
            return "/reply"
        case .writeComment:
            return "/reply"
        case .makeBookmark:
            return "/bookmark"
        case .deleteBookmark(let postId):
            return "/bookmark/\(postId)"
        case .deleteComment(let postId):
            return "/reply/delete/\(postId)"
        case .reportComment:
            return "/reply-reports"
        case .deletePost(let postId):
            return "/posts/\(postId)"
        case .editPost(let postId, _):
            return "/posts/\(postId)"
        case .likePost:
            return "/like"
        case.unLikePost(let postId):
            return "/like/\(postId)"
        }
    }
    
    public var method: Moya.Method {
        switch self{
        case .fetchFeeds,
                .fetchPost,
                .fetchComment:
            return .get
        case .writeComment,
                .makeBookmark,
                .reportComment,
                .likePost:
            return .post
        case .deleteBookmark,
                .deletePost,
                .unLikePost:
            return .delete
        case .deleteComment,
                .editPost:
            return .put
        }
    }
    
    public var task: Moya.Task {
        switch self{
        case .fetchFeeds(let page, let size):
            return .requestParameters(parameters: ["page" : page + 1, "size" : size, "sort" : "recommended", "distance" : 100], encoding: URLEncoding.queryString)
        case .fetchComment(let postId):
            return .requestParameters(parameters: ["postNo" : postId], encoding: URLEncoding.queryString)
        case .reportComment(let reportCommentModel):
            return .requestJSONEncodable(reportCommentModel)
        case .editPost(_, let editPostModel):
            return .requestJSONEncodable(editPostModel)
        case .fetchPost,
                .deleteBookmark,
                .deleteComment,
                .deletePost,
                .unLikePost:
            return .requestPlain
        case .writeComment(let commentModel):
            return .requestJSONEncodable(commentModel)
        case .makeBookmark(let postModel):
            return .requestJSONEncodable(postModel)
        case .likePost(let likePost):
            return .requestJSONEncodable(likePost)
        }
    }
    
    public var headers: [String : String]? {
        switch self{
        case .fetchFeeds,
                .fetchPost,
                .fetchComment,
                .writeComment,
                .makeBookmark,
                .deleteBookmark,
                .deleteComment,
                .reportComment,
                .deletePost,
                .editPost,
                .likePost,
                .unLikePost:
            return ["Content-type": "application/json",
                    "Authorization": accessToken]
        }
    }
}
