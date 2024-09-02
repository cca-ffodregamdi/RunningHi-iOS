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
    func fetchFeeds(page: Int, size: Int, sort: String, distance: Int) -> Observable<([FeedModel], Int)>
    func fetchFeed(postId: Int) -> Observable<FeedModel>
    func fetchPost(postId: Int) -> Observable<FeedDetailModel>
    func fetchComment(postId: Int) -> Observable<[CommentModel]>
    func writeComment(commentModel: WriteCommentReqesutDTO) -> Observable<WriteCommentModel>
    func makeBookmark(post: BookmarkRequestDTO) -> Observable<Any>
    func deleteBookmark(postId: Int) -> Observable<Any>
    func deleteComment(postId: Int) -> Observable<Any>
    func reportComment(reportCommentModel: ReportCommentRequestDTO) -> Observable<Any>
    func deletePost(postId: Int) -> Observable<Any>
    func editPost(postId: Int, editPostModel: EditFeedRequestDTO) -> Observable<Any>
    func likePost(likePost: FeedLikeRequestDTO) -> Observable<FeedLikeModel>
    func unLikePost(postId: Int) -> Observable<FeedLikeModel>
    func editComment(commentId: Int, editCommentModel: EditCommentRequestDTO) -> Observable<Any>
    func fetchOptionFeed(page: Int, size: Int, option: FeedOptionType) -> Observable<([FeedModel], Int)>
    func saveFeedImage(image: Data) -> Observable<String>
    func saveFeed(feedModel: EditFeedModel, imageURL: String) -> Observable<Void>
    func editFeed(feedModel: EditFeedModel, imageURL: String) -> Observable<Void>
}
