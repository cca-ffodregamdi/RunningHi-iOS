//
//  MyUseCase.swift
//  Domain
//
//  Created by 유현진 on 7/15/24.
//

import Foundation
import RxSwift

public final class MyUseCase: MyUseCaseProtocol{
    private let repository:  MyRepositoryProtocol
    
    public init(repository: MyRepositoryProtocol) {
        self.repository = repository
    }
    
    public func fetchNotice() -> Observable<[NoticeModel]> {
        return self.repository.fetchNotice()
    }
    
    public func fetchFAQ() -> Observable<[FAQModel]> {
        return self.repository.fetchFAQ()
    }
    
    public func fetchFeedback() -> Observable<[FeedbackModel]> {
        return self.repository.fetchFeedback()
    }
    
    public func fetchFeedbackDetail(feedbackId: Int) -> Observable<FeedbackDetailModel> {
        return self.repository.fetchFeedbackDetail(feedbackId: feedbackId)
    }
    
    public func fetchUserInfo() -> Observable<MyUserInfoModel> {
        return self.repository.fetchUserInfo()
    }
    
    public func fetchMyFeed(page: Int, size: Int) -> Observable<([FeedModel], Int)> {
        return self.repository.fetchMyFeed(page: page, size: size)
    }
    
    public func makeBookmark(post: BookmarkRequestDTO) -> Observable<Any> {
        return self.repository.makeBookmark(post: post)
    }
    
    public func deleteBookmark(postId: Int) -> Observable<Any> {
        return self.repository.deleteBookmark(postId: postId)
    }
    
    public func deleteKeyChain() {
        return self.repository.deleteKeyChain()
    }
    
    public func signOut(loginType: LoginType) -> Observable<Any> {
        return self.repository.signOut(loginType: loginType)
    }
    
    public func editMyNickname(request: EditMyNicknameRequest) -> Observable<Any> {
        return self.repository.editMyNickname(request: request)
    }
    
    public func editMyProfileImage(request: EditMyProfileImageRequestModel) -> Observable<Any> {
        return self.repository.editMyProfileImage(request: request)
    }
    
    public func deleteMyProfileImage() -> Observable<Any> {
        return self.repository.deleteMyProfileImage()
    }
    
    public func makeFeedback(request: MakeFeedbackRequestModel) -> Observable<Any> {
        return self.repository.makeFeedback(request: request)
    }
}
