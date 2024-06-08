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
    }
    
    public enum Mutation{
        case setPost(FeedDetailModel)
    }
    
    public struct State{
        var postId: Int
        var postModel: FeedDetailModel?
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
        }
    }
    
    public func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        switch mutation{
        case .setPost(let model):
            newState.postModel = model
        }
        return newState
    }
}
