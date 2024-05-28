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

final class FeedReactor: Reactor{
    
    public enum Action{
        case fetchFeeds
    }
    
    public enum Mutation{
        case setFeeds([FeedModel])
    }
    
    public struct State{
        var feeds: [FeedModel] = []
    }

    public let initialState: State
    private let feedUseCase: FeedUseCase
    
    public init(){
        self.initialState = State()
        self.feedUseCase = FeedUseCase(repository: FeedRepositoryImplementation())
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action{
        case .fetchFeeds:
            return self.feedUseCase.fetchFeeds(page: 0, size: 10, keyword: [])
                .map{ Mutation.setFeeds($0)}
            
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        switch mutation{
        case .setFeeds(let feeds):
            newState.feeds = feeds
        }
        return newState
    }
}
