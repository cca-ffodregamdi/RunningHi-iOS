//
//  MyRepositoryProtocol.swift
//  Domain
//
//  Created by 유현진 on 7/15/24.
//

import Foundation
import RxSwift

public protocol MyRepositoryProtocol{
    func fetchNotice() -> Observable<[NoticeModel]>
    func fetchFAQ() -> Observable<[FAQModel]>
    func fetchFeedback() -> Observable<[FeedbackModel]>
    func fetchUserInfo() -> Observable<MyUserInfoModel>
    
    func fetchMyFeed(page: Int, size: Int) -> Observable<([FeedModel], Int)>
    func makeBookmark(post: BookmarkRequestDTO) -> Observable<Any>
    func deleteBookmark(postId: Int) -> Observable<Any>
}
