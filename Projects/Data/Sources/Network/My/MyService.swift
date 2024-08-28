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
    case fetchFeedbackDetail(feedbackId: Int)
    case fetchUserInfo
    case makeFeedback(request: MakeFeedbackRequestModel)
    
    case fetchMyFeed(page: Int, size: Int)
    case makeBookmark(post: BookmarkRequestDTO)
    case deleteBookmark(postId: Int)
    
    case signOutApple
    case signOutKakao
    
    case editMyNickname(request: EditMyNicknameRequest)
    case editMyProfileImage(request: MultipartFormData)
    case deleteMyProfileImage
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
        case .fetchFeedbackDetail(let feedbackId): "/feedbacks/\(feedbackId)"
        case .fetchUserInfo: "/members"
        case .fetchMyFeed: "/posts/my-feed"
        case .makeBookmark: "/bookmark"
        case .deleteBookmark(let postId): "/bookmark/\(postId)"
        case .signOutKakao: "/unlink/kakao"
        case .signOutApple: "/unlink/apple"
        case .editMyProfileImage: "/member/profile-image"
        case .editMyNickname: "/members"
        case .deleteMyProfileImage: "/member/profile-image"
        case .makeFeedback: "/feedbacks"
        }
    }
    
    public var method: Moya.Method{
        switch self{
        case .fetchNotice, .fetchFAQ, .fetchFeedback, .fetchUserInfo, .fetchMyFeed, .fetchFeedbackDetail: .get
        case .makeBookmark, .makeFeedback: .post
        case .deleteBookmark: .delete
        case .signOutApple, .signOutKakao, .editMyProfileImage, .editMyNickname: .put
        case .deleteMyProfileImage: .delete
        }
    }
    
    public var task: Task{
        switch self{
        case .fetchNotice, .fetchFAQ, .fetchFeedback, .fetchUserInfo, .deleteBookmark: .requestPlain
        case .fetchMyFeed(let page, let size): .requestParameters(parameters: ["page" : page + 1, "size" : size], encoding: URLEncoding.queryString)
        case .makeBookmark(let postModel): .requestJSONEncodable(postModel)
        case .signOutApple, .signOutKakao: .requestPlain
        case .editMyProfileImage(let request): .uploadMultipart([request])
        case .editMyNickname(let request): .requestJSONEncodable(request)
        case .deleteMyProfileImage, .fetchFeedbackDetail: .requestPlain
        case .makeFeedback(let request): .requestJSONEncodable(request)
        }
    }
    
    public var headers: [String : String]?{
        switch self{
        case .fetchNotice, .fetchFAQ, .fetchFeedback, .fetchUserInfo, .fetchMyFeed, .makeBookmark, .deleteBookmark, .signOutApple, .signOutKakao, .editMyNickname, .deleteMyProfileImage, .fetchFeedbackDetail, .makeFeedback:
            ["Content-type": "application/json",
                    "Authorization": accessToken]
        case .editMyProfileImage:
            ["Content-type": "multipart/form-data",
                    "Authorization": accessToken]
        }
    }
}
