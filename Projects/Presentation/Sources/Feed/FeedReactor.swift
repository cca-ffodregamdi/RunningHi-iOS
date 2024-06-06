//
//  FeedReactor.swift
//  Presentation
//
//  Created by 유현진 on 5/21/24.
//

import Foundation
import ReactorKit
import Domain
import Data
import RxSwift

final public class FeedReactor: Reactor{
    
    public enum Action{
        case fetchFeeds
        case refresh
    }
    
    public enum Mutation{
        case setFeeds([FeedModel])
        case setEndRefreshing(Bool)
    }
    
    public struct State{
        var feeds: [FeedModel] = []
        var isEndRefreshing = true
    }

    public let initialState: State
    private let feedUseCase: FeedUseCase
    
    public init(feedUseCase: FeedUseCase){
        self.initialState = State()
        self.feedUseCase = feedUseCase
    }
    
    public func mutate(action: Action) -> Observable<Mutation> {
        switch action{
        case .fetchFeeds:
            return self.feedUseCase.fetchFeeds(page: 0, size: 10, keyword: [])
                .map{ Mutation.setFeeds($0)}
        case .refresh:
            return Observable.concat([
                Observable.just(Mutation.setEndRefreshing(false)),
                feedUseCase.fetchFeeds(page: 0, size: 10, keyword: [])
                    .map{ Mutation.setFeeds($0)},
                Observable.just(Mutation.setEndRefreshing(true)),
            ])
        }
    }
    
    public func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        switch mutation{
        case .setFeeds(let feeds):
            newState.feeds = feeds
        case .setEndRefreshing(let value):
            newState.isEndRefreshing = value
        }
        return newState
    }
}
