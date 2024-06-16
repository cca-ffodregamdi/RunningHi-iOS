//
//  FeedReactor.swift
//  Presentation
//
//  Created by 유현진 on 5/21/24.
//

import Foundation
import ReactorKit
import Domain
import RxSwift

final public class FeedReactor: Reactor{
    
    public enum Action{
        case fetchFeeds
        case refresh
    }
    
    public enum Mutation{
        case setFeeds([FeedModel], Int)
        case addFeeds([FeedModel], Int)
        case setRefreshing(Bool)
        case setLoading(Bool)
    }
    
    public struct State{
        var feeds: [FeedModel] = []
        var isRefreshing: Bool = false
        var isLoading: Bool = false
        var pageNumber: Int = 0
        var totalPages: Int = 1
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
            guard !currentState.isLoading else { return .empty()}
            guard currentState.pageNumber < currentState.totalPages else { return .empty()}
            
            return Observable.concat([
                Observable.just(Mutation.setLoading(true)),
                self.feedUseCase.fetchFeeds(page: currentState.pageNumber)
                    .map{ Mutation.addFeeds($0.0, $0.1)},
                Observable.just(Mutation.setLoading(false))
            ])
        case .refresh:
            guard !currentState.isRefreshing else { return .empty()}
            
            return Observable.concat([
                Observable.just(Mutation.setRefreshing(true)),
                Observable.just(Mutation.setLoading(true)),
                feedUseCase.fetchFeeds(page: 0)
                    .map{ Mutation.setFeeds($0.0, $0.1)},
                Observable.just(Mutation.setLoading(false)),
                Observable.just(Mutation.setRefreshing(false)),
            ])
        }
    }
    
    public func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        switch mutation{
        case .setFeeds(let feeds, let totalPages):
            newState.feeds = feeds
            newState.pageNumber = 1
            newState.totalPages = totalPages
        case .addFeeds(let feeds, let totalPages):
            newState.feeds += feeds
            newState.pageNumber += 1
            newState.totalPages = totalPages
        case .setRefreshing(let value):
            newState.isRefreshing = value
        case .setLoading(let value):
            newState.isLoading = value
        }
        return newState
    }
}
