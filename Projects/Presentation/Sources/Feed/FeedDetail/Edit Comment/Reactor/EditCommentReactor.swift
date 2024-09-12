//
//  EditCommentReactor.swift
//  Presentation
//
//  Created by 유현진 on 7/13/24.
//

import Foundation
import ReactorKit
import Domain

public class EditCommentReactor: Reactor{
    public enum Action{
        case editComment(EditCommentRequestModel)
    }
    
    public enum Mutation{
        case setIsEdited(Bool)
    }
    
    public struct State{
        var commentModel: CommentModel
        var isEdited: Bool = false
    }
    
    public var initialState: State
    private var feedUseCase: FeedUseCase
    
    public init(feedUseCase: FeedUseCase, commentModel: CommentModel) {
        self.initialState = State(commentModel: commentModel)
        self.feedUseCase = feedUseCase
    }
    
    public func mutate(action: Action) -> Observable<Mutation> {
        switch action{
        case .editComment(let editCommentContent):
            return feedUseCase.editComment(commentId: currentState.commentModel.commentId, editCommentModel: editCommentContent).map{ _ in Mutation.setIsEdited(true)}
            
        }
    }
    
    public func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        switch mutation{
        case .setIsEdited(let value):
            newState.isEdited = value
        }
        return newState
    }
}
