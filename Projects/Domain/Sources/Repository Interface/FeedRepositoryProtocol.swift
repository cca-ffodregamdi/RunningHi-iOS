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
    func fetchFeedDetail(postId: Int) -> Observable<FeedDetailModel>
    func fetchComment(postId: Int) -> Observable<[CommentModel]>
    func writeComment(commentModel: WriteCommentReqesutModel) -> Observable<WriteCommentModel>
    func makeBookmark(post: BookmarkRequestModel) -> Observable<Any>
    func deleteBookmark(postId: Int) -> Observable<Any>
    func deleteComment(postId: Int) -> Observable<Any>
    func reportComment(reportCommentModel: ReportCommentRequestModel) -> Observable<Any>
    func deletePost(postId: Int) -> Observable<Any>
    func editPost(postId: Int, editPostModel: EditFeedRequestModel) -> Observable<Any>
    func likePost(likePost: FeedLikeRequestModel) -> Observable<FeedLikeModel>
    func unLikePost(postId: Int) -> Observable<FeedLikeModel>
    func editComment(commentId: Int, editCommentModel: EditCommentRequestModel) -> Observable<Any>
    func fetchOptionFeed(page: Int, size: Int, option: FeedOptionType) -> Observable<([FeedModel], Int)>
    func saveFeedImage(image: Data) -> Observable<String>
    func saveFeed(feedModel: EditFeedModel, imageURL: String) -> Observable<Void>
    func editFeed(feedModel: EditFeedModel, imageURL: String) -> Observable<Void>
}
