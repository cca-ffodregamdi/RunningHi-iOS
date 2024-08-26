//
//  MyUseCaseProtocol.swift
//  Domain
//
//  Created by 유현진 on 7/15/24.
//

import Foundation
import RxSwift

protocol MyUseCaseProtocol{
    func fetchNotice() -> Observable<[NoticeModel]>
    func fetchFAQ() -> Observable<[FAQModel]>
    func fetchFeedback() -> Observable<[FeedbackModel]>
    func fetchUserInfo() -> Observable<MyUserInfoModel>
    
    func editMyNickname(request: EditMyNicknameRequest) -> Observable<Any>
    func editMyProfileImage(request: EditMyProfileImageRequestModel) -> Observable<Any>
    func deleteMyProfileImage() -> Observable<Any>
    func fetchMyFeed(page: Int, size: Int) -> Observable<([FeedModel], Int)>
    func makeBookmark(post: BookmarkRequestDTO) -> Observable<Any>
    func deleteBookmark(postId: Int) -> Observable<Any>
    
    func deleteKeyChain()
    
    func signOut(loginType: LoginType) -> Observable<Any>
}
