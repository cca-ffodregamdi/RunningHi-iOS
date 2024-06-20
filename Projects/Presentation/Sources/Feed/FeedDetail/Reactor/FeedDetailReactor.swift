//
//  FeedDetailReactor.swift
//  Presentation
//
//  Created by 유현진 on 6/8/24.
//

import Foundation
import ReactorKit
import RxSwift
import Domain

public class FeedDetailReactor: Reactor{
    
    public enum Action{
        case fetchPost
        case fetchComment
        case writeComment(WriteCommentReqesutDTO)
        case makeBookmark(BookmarkRequestDTO)
        case deleteBookmark(Int)
        case deleteComment(CommentModel)
    }
    
    public enum Mutation{
        case setPost(FeedDetailModel)
        case setComment([CommentModel], Int)
        case addComment([CommentModel], Int)
        case writeComment(WriteCommentResponseModel)
        case setWroteComment(Bool)
        case setBookmark(Bool)
        case setLoading(Bool)
        case deleteComment
    }
    
    public struct State{
        var postId: Int
        var postModel: FeedDetailModel?
        var commentModels: [CommentModel] = []
        var totalPages: Int = 1
        var pageNumber: Int = 0
        var isWroteComment: Bool = false
        var isLike: Bool = false
        var isBookmark: Bool = false
        var isLoading: Bool = false
    }
    
    public var initialState: State
    private let feedUseCase: FeedUseCase
    
    public init(feedUseCase: FeedUseCase, postId: Int) {
        self.initialState = State(postId: postId)
        self.feedUseCase = feedUseCase
    }

    public func mutate(action: Action) -> Observable<Mutation> {
        switch action{
        case .fetchPost: return feedUseCase.fetchPost(postId: currentState.postId).map{ Mutation.setPost($0) }
            
        case .fetchComment:
            guard !currentState.isLoading else { return .empty()}
            guard currentState.pageNumber < currentState.totalPages else { return .empty()}
            return Observable.concat([
                Observable.just(Mutation.setLoading(true)),
                feedUseCase.fetchComment(postId: currentState.postId, page: currentState.pageNumber).map{ Mutation.addComment($0.0, $0.1) },
                Observable.just(Mutation.setLoading(false))
            ])
            
        case .writeComment(let commentModel):
            return Observable.concat([
                feedUseCase.writeComment(commentModel: commentModel).map{ Mutation.writeComment($0) },
                Observable.just(Mutation.setLoading(true)),
                feedUseCase.fetchComment(postId: commentModel.postNo, page: 0).map{ Mutation.setComment($0.0, $0.1) },
                Observable.just(Mutation.setLoading(false)),
                Observable.just(Mutation.setWroteComment(true)),
                Observable.just(Mutation.setWroteComment(false))
            ])
            
        case .makeBookmark(let bookmarkRequest):
            return feedUseCase.makeBookmark(post: bookmarkRequest).map{ _ in Mutation.setBookmark(true) }
        case .deleteBookmark(let postId):
            return feedUseCase.deleteBookmark(postId: postId).map{_ in Mutation.setBookmark(false)}
            
        case .deleteComment(let commentModel):
            return Observable.concat([
                feedUseCase.deleteComment(postId: commentModel.commentId).map { _ in Mutation.deleteComment },
                Observable.just(Mutation.setLoading(true)),
                feedUseCase.fetchComment(postId: commentModel.postId, page: 0).map{ Mutation.setComment($0.0, $0.1) },
                Observable.just(Mutation.setLoading(false)),
            ])
        }
    }
    
    public func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        switch mutation{
        case .setPost(let model):
            newState.postModel = model
        case .setComment(let models, let totalPages):
            newState.commentModels = models
            newState.postModel?.commentCount = models.count
            newState.pageNumber = 1
            newState.totalPages = totalPages
        case .addComment(let models, let totalPages):
            newState.commentModels += models
            newState.pageNumber += 1
            newState.totalPages = totalPages
        case .setLoading(let value):
            newState.isLoading = value
        case .writeComment(let model):
            newState.postModel?.likeCount = model.likeCount
        case .setWroteComment(let value):
            newState.isWroteComment = value
        case .setBookmark(let value):
            newState.isBookmark = value
        case .deleteComment:
            break
        }
        return newState
    }
}
