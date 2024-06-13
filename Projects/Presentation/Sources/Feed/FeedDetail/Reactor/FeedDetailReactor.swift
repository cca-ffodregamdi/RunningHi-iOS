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
    }
    
    public enum Mutation{
        case setPost(FeedDetailModel)
        case setComment([CommentModel])
        case WriteComment(WriteCommentResponseModel)
        case setWroteComment(Bool)
    }
    
    public struct State{
        var postId: Int
        var postModel: FeedDetailModel?
        var commentModels: [CommentModel] = []
        var isWroteComment: Bool = false
    }
    
    public var initialState: State
    private let feedUseCase: FeedUseCase
    
    public init(feedUseCase: FeedUseCase, postId: Int) {
        self.initialState = State(postId: postId)
        self.feedUseCase = feedUseCase
    }

    public func mutate(action: Action) -> Observable<Mutation> {
        switch action{
        case .fetchPost: feedUseCase.fetchPost(postId: currentState.postId).map{ Mutation.setPost($0) }
        case .fetchComment: feedUseCase.fetchComment(postId: currentState.postId).map{ Mutation.setComment($0) }
        case .writeComment(let commentModel): Observable.concat([
            feedUseCase.writeComment(commentModel: commentModel).map{ Mutation.WriteComment($0) },
            feedUseCase.fetchComment(postId: commentModel.postNo).map{ Mutation.setComment($0) },
            Observable.just(Mutation.setWroteComment(true)),
            Observable.just(Mutation.setWroteComment(false))])
        }
    }
    
    public func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        switch mutation{
        case .setPost(let model):
            newState.postModel = model
        case .setComment(let models):
            newState.commentModels = models
            newState.postModel?.commentCount = models.count
        case .WriteComment(let models):
            break
        case .setWroteComment(let value):
            newState.isWroteComment = value
        }
        return newState
    }
}
