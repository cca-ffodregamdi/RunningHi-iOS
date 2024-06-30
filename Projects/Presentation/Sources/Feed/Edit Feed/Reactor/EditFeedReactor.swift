//
//  EditFeedReactor.swift
//  Presentation
//
//  Created by 유현진 on 6/26/24.
//

import Foundation
import ReactorKit
import Domain

public class EditFeedReactor: Reactor{
    
    public enum Action{
        case fetchPost
        case editfeed(EditFeedRequestDTO)
    }
    
    public enum Mutation{
        case setFeedModel(FeedDetailModel)
        case setEditedFeed(Bool)
    }
    
    public struct State{
        let postId: Int
        var feed: FeedDetailModel?
        var editedFeed: Bool = false
    }
    
    public var initialState: State
    private let feedUsecase: FeedUseCase
    public init(feedUsecase: FeedUseCase, postId: Int) {
        self.initialState = State(postId: postId)
        self.feedUsecase = feedUsecase
    }
    
    public func mutate(action: Action) -> Observable<Mutation> {
        switch action{
        case .fetchPost:
            return feedUsecase.fetchPost(postId: currentState.postId).map{ Mutation.setFeedModel($0) }
        case .editfeed(let model):
            return feedUsecase.editPost(postId: currentState.postId, editPostModel: model).map{ _ in Mutation.setEditedFeed(true) }
        }
    }
    
    public func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        switch mutation{
        case .setFeedModel(let model):
            newState.feed = model
        case .setEditedFeed(let value):
            newState.editedFeed = value
        }
        return newState
    }
}
