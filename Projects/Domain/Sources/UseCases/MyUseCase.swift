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
}
