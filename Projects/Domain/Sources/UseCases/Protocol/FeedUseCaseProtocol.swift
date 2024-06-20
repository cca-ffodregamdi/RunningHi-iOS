//
//  FeedUseCaseProtocol.swift
//  Domain
//
//  Created by 유현진 on 5/26/24.
//

import Foundation
import RxSwift

protocol FeedUseCaseProtocol{
    func fetchFeeds(page: Int) -> Observable<([FeedModel], Int)>
    func fetchPost(postId: Int) -> Observable<FeedDetailModel>
    func fetchComment(postId: Int, page: Int, size: Int) -> Observable<([CommentModel], Int)>
    func writeComment(commentModel: WriteCommentReqesutDTO) -> Observable<WriteCommentResponseModel>
    func makeBookmark(post: BookmarkRequestDTO) -> Observable<Any>
    func deleteBookmark(postId: Int) -> Observable<Any>
    func deleteComment(postId: Int) -> Observable<Any>
}
