//
//  FeedUseCase.swift
//  Domain
//
//  Created by 유현진 on 5/26/24.
//

import Foundation
import RxSwift

public final class FeedUseCase: FeedUseCaseProtocol{
    
    private let repository: FeedRepositoryProtocol

    public init(repository: FeedRepositoryProtocol) {
        self.repository = repository
    }
    
    public func fetchFeeds(page: Int) -> Observable<([FeedModel], Int)>{
        return repository.fetchFeeds(page: page)
    }
    
    public func fetchPost(postId: Int) -> Observable<FeedDetailModel> {
        return repository.fetchPost(postId: postId)
    }
    
    public func fetchComment(postId: Int) -> Observable<[CommentModel]> {
        return  repository.fetchComment(postId: postId)
    }
    
    public func writeComment(commentModel: WriteCommentReqesutDTO) -> Observable<WriteCommentResponseModel> {
        return repository.writeComment(commentModel: commentModel)
    }
    
    public func makeBookmark(post: BookmarkRequestDTO) -> Observable<Any> {
        return repository.makeBookmark(post: post)
    }
    
    public func deleteBookmark(postId: Int) -> Observable<Any> {
        return repository.deleteBookmark(postId: postId)
    }
    
    public func deleteComment(postId: Int) -> Observable<Any> {
        return repository.deleteComment(postId: postId)
    }
    
    public func reportComment(reportCommentModel: ReportCommentRequestDTO) -> Observable<Any> {
        return repository.reportComment(reportCommentModel: reportCommentModel)
    }
    
    public func deletePost(postId: Int) -> Observable<Any> {
        return repository.deletePost(postId: postId)
    }
    
    public func editPost(postId: Int, editPostModel: EditFeedRequestDTO) -> Observable<Any> {
        return repository.editPost(postId: postId, editPostModel: editPostModel)
    }
    
    public func likePost(likePost: FeedLikeRequestDTO) -> Observable<FeedLikeResponseModel> {
        return repository.likePost(likePost: likePost)
    }
    
    public func unLikePost(postId: Int) -> Observable<FeedLikeResponseModel> {
        return repository.unLikePost(postId: postId)
    }
    
    public func editComment(commentId: Int, editCommentModel: EditCommentRequestDTO) -> Observable<Any> {
        return repository.editComment(commentId: commentId, editCommentModel: editCommentModel)
    }
}
