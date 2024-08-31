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
    case fetchFeeds(page: Int, size: Int = 10, sort: String, distance: Int)
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
    case editComment(commentId: Int, editCommentModel: EditCommentRequestDTO)
    case fetchBookmarkedFeeds(pages: Int, size: Int)
    case fetchMyFeed(page: Int, size: Int)
    case editFeed(feedData: CreateFeedRequestDTO)
    case saveRunningImage(image: Data)
}

extension FeedService: TargetType{
    public var baseURL: URL {
        return .init(string: "https://runninghi.store/api/v1")!
    }
    
    public var accessToken: String{
        return KeyChainManager.read(key: .runningHiAccessTokenkey)!
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
        case .editComment(let commentId, _):
            return "/reply/update/\(commentId)"
        case .fetchBookmarkedFeeds:
            return "/posts/bookmarked"
        case .fetchMyFeed:
            return "/posts/my-feed"
        case .editFeed:
            return "/posts"
        case .saveRunningImage:
            return "/image"
        }
    }
    
    public var method: Moya.Method {
        switch self{
        case .fetchFeeds,
                .fetchPost,
                .fetchComment,
                .fetchBookmarkedFeeds,
                .fetchMyFeed:
            return .get
        case .writeComment,
                .makeBookmark,
                .reportComment,
                .likePost,
                .saveRunningImage:
            return .post
        case .deleteBookmark,
                .deletePost,
                .unLikePost:
            return .delete
        case .deleteComment,
                .editPost,
                .editComment,
                .editFeed:
            return .put
        }
    }
    
    public var task: Moya.Task {
        switch self{
        case .fetchFeeds(let page, let size, let sort, let distance):
            return .requestParameters(parameters: ["page" : page + 1, "size" : size, "sort" : sort, "distance" : distance], encoding: URLEncoding.queryString)
        case .fetchComment(let postId):
            return .requestParameters(parameters: ["postNo" : postId], encoding: URLEncoding.queryString)
        case .reportComment(let reportCommentModel):
            return .requestJSONEncodable(reportCommentModel)
        case .editPost(_, let editPostModel):
            return .requestJSONEncodable(editPostModel)
        case .editComment(_, let editCommentModel):
            return .requestJSONEncodable(editCommentModel)
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
        case .fetchBookmarkedFeeds(let page, let size):
            return .requestParameters(parameters: ["page" : page + 1, "size" : size], encoding: URLEncoding.queryString)
        case .fetchMyFeed(let page, let size):
                return .requestParameters(parameters: ["page" : page + 1, "size" : size], encoding: URLEncoding.queryString)
        case .editFeed(let feedData):
            return .requestJSONEncodable(feedData)
        case .saveRunningImage(let image):
            let request = MultipartFormData(provider: .data(image), name: "image", fileName: "fileName.jpeg", mimeType: "image/jpeg")
            return .uploadMultipart([request])
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
                .unLikePost,
                .editComment,
                .fetchBookmarkedFeeds,
                .editFeed,
                .fetchMyFeed:
            return ["Content-type": "application/json",
                    "Authorization": accessToken]
        case .saveRunningImage:
            return ["Content-type": "multipart/form-data",
                    "Authorization": accessToken]
        }
    }
}
