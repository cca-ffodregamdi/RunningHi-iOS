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
    
    //MARK: - Properties
    
    public let initialState: State
    private let feedUseCase: FeedUseCase
    
    public enum Action{
        case createRunningFeed(EditFeedModel)
        case tapRepresentButton(FeedRepresentType)
    }
    
    public enum Mutation{
        case finishCreateRunningFeed
        case setFeedRepresentType(FeedRepresentType)
    }
    
    public struct State{
        var isFinishCreateRunningFeed = false
        var representType: FeedRepresentType?
    }
    
    //MARK: - Lifecycle
    
    public init(feedUseCase: FeedUseCase) {
        self.initialState = State()
        self.feedUseCase = feedUseCase
    }
    
    //MARK: - Configure
    
    public func mutate(action: Action) -> Observable<Mutation> {
        switch action{
        case .createRunningFeed(let feedModel):
            return feedUseCase.editFeed(feedModel: feedModel)
                .map { Mutation.finishCreateRunningFeed }
        case .tapRepresentButton(let type):
            return Observable.just(Mutation.setFeedRepresentType(type))
        }
    }
    
    public func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        switch mutation{
        case .finishCreateRunningFeed:
            newState.isFinishCreateRunningFeed = true
        case .setFeedRepresentType(let type):
            newState.representType = type
        }
        return newState
    }
}
