//
//  MyRepositoryImplementation.swift
//  Data
//
//  Created by 유현진 on 7/15/24.
//

import Foundation
import Domain
import Moya
import RxMoya
import RxSwift

public final class MyRepositoryImplementation: MyRepositoryProtocol{
    private let service = MoyaProvider<MyService>()
    
    public init() { }
    
    public func fetchNotice() -> Observable<[NoticeModel]> {
        return service.rx.request(.fetchNotice)
            .filterSuccessfulStatusCodes()
            .map{ response -> [NoticeModel] in
                let noticesResponse = try JSONDecoder().decode(NoticeResponseDTO.self, from: response.data)
                return noticesResponse.data.content
            }.asObservable()
            .catch { error in
                print("MyRepositoryImplementation fetchNotice error = \(error)")
                return Observable.error(error)
            }
    }
    
    public func fetchFAQ() -> Observable<[FAQModel]> {
        return service.rx.request(.fetchFAQ)
            .filterSuccessfulStatusCodes()
            .map{ response -> [FAQModel] in
                let FAQResponse = try JSONDecoder().decode(FAQResponseDTO.self, from: response.data)
                return FAQResponse.data
            }.asObservable()
            .catch { error in
                print("MyRepositoryImplementation fetchFAQ error = \(error)")
                return Observable.error(error)
            }
    }
    
    public func fetchFeedback() -> Observable<[FeedbackModel]> {
        return service.rx.request(.fetchFeedback)
            .filterSuccessfulStatusCodes()
            .map{ response -> [FeedbackModel] in
                let feedbackResponse = try JSONDecoder().decode(FeedbackResponseDTO.self, from: response.data)
                return feedbackResponse.data.content.map{$0.toEntity()}
            }.asObservable()
            .catch { error in
                print("MyRepositoryImplementation fetchFeedback error = \(error)")
                return Observable.error(error)
            }
    }
    
    public func fetchFeedbackDetail(feedbackId: Int) -> Observable<FeedbackDetailModel> {
        return service.rx.request(.fetchFeedbackDetail(feedbackId: feedbackId))
            .filterSuccessfulStatusCodes()
            .map{ response -> FeedbackDetailModel in
                let feedbackDetailResponse = try JSONDecoder().decode(FeedbackDetailResponseDTO.self, from: response.data)
                return feedbackDetailResponse.data.toEntity()
            }.asObservable()
            .catch { error in
                print("MyRepositoryImplementation fetchFeedbackDetail error = \(error)")
                return Observable.error(error)
            }
    }
    
    public func fetchUserInfo() -> Observable<MyUserInfoModel> {
        return service.rx.request(.fetchUserInfo)
            .filterSuccessfulStatusCodes()
            .map{ response -> MyUserInfoModel in
                let userInfoResponse = try JSONDecoder().decode(MyUserInfoDTO.self, from: response.data)
                return userInfoResponse.data
            }.asObservable()
            .catch { error in
                print("MyRepositoryImplementation fetchUserInfo error = \(error)")
                return Observable.error(error)
            }
    }
    
    public func fetchMyFeed(page: Int, size: Int) -> Observable<([FeedModel], Int)> {
        return service.rx.request(.fetchMyFeed(page: page, size: size))
            .filterSuccessfulStatusCodes()
            .map{ response -> ([FeedModel], Int) in
                let feedResponse = try JSONDecoder().decode(FeedResponseDTO.self, from: response.data)
                return (feedResponse.data.content, feedResponse.data.totalPages)
            }
            .asObservable()
            .catch{ error in
                print("MyRepositoryImplementation fetchMyFeed error = \(error)")
                return Observable.error(error)
            }
    }
    
    public func makeBookmark(post: BookmarkRequestDTO) -> Observable<Any> {
        return service.rx.request(.makeBookmark(post: post))
            .filterSuccessfulStatusCodes()
            .map{ _ in
                return Observable.just(())
            }
            .asObservable()
    }
    
    public func deleteBookmark(postId: Int) -> Observable<Any> {
        return service.rx.request(.deleteBookmark(postId: postId))
            .filterSuccessfulStatusCodes()
            .map{ _ in
                return Observable.just(())
            }.asObservable()
    }
    
    public func deleteKeyChain() {
        KeyChainManager.reset()
    }
    
    public func signOut(loginType: LoginType) -> Observable<Any> {
        switch loginType{
        case .apple:
            return service.rx.request(.signOutApple)
                .filterSuccessfulStatusCodes()
                .map{_ in return Observable.just(())}
                .asObservable()
        case .kakao:
            return service.rx.request(.signOutKakao)
                .filterSuccessfulStatusCodes()
                .map{_ in return Observable.just(())}
                .asObservable()
        }
    }
    
    public func editMyNickname(request: EditMyNicknameRequest) -> Observable<Any> {
        return service.rx.request(.editMyNickname(request: request))
            .filterSuccessfulStatusCodes()
            .map{_ in return Observable.just(())}
            .asObservable()
    }
    
    public func editMyProfileImage(request: EditMyProfileImageRequestModel) -> Observable<Any> {
        return service.rx.request(.editMyProfileImage(request: EditProfileImageRequestDTO(data: request).toRequsetMutipartFormData()))
            .filterSuccessfulStatusCodes()
            .map{_ in return Observable.just(())}
            .asObservable()
    }
    
    public func deleteMyProfileImage() -> Observable<Any> {
        return service.rx.request(.deleteMyProfileImage)
            .filterSuccessfulStatusCodes()
            .map{_ in return Observable.just(())}
            .asObservable()
    }
    
    public func makeFeedback(request: MakeFeedbackRequestModel) -> Observable<Any> {
        return service.rx.request(.makeFeedback(request: request))
            .filterSuccessfulStatusCodes()
            .map{_ in return Observable.just(())}
            .asObservable()
    }
}
