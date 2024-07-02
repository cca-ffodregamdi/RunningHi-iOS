//
//  FeedRepositoryProtocol.swift
//  Domain
//
//  Created by 유현진 on 5/26/24.
//

import Foundation
import Moya
import RxSwift

public protocol FeedRepositoryProtocol{
    func fetchFeeds(page: Int) -> Observable<([FeedModel], Int)>
    func fetchPost(postId: Int) -> Observable<FeedDetailModel>
    func fetchComment(postId: Int) -> Observable<[CommentModel]>
    func writeComment(commentModel: WriteCommentReqesutDTO) -> Observable<WriteCommentResponseModel>
    func makeBookmark(post: BookmarkRequestDTO) -> Observable<Any>
    func deleteBookmark(postId: Int) -> Observable<Any>
    func deleteComment(postId: Int) -> Observable<Any>
    func reportComment(reportCommentModel: ReportCommentRequestDTO) -> Observable<Any>
    func deletePost(postId: Int) -> Observable<Any>
    func editPost(postId: Int, editPostModel: EditFeedRequestDTO) -> Observable<Any>
    func likePost(likePost: FeedLikeRequestDTO) -> Observable<Any>
    func unLikePost(postId: Int) -> Observable<Any>
}
