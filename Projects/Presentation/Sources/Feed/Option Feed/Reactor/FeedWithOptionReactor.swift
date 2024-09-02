//
//  FeedWithOptionReactor.swift
//  Presentation
//
//  Created by 유현진 on 7/27/24.
//

import Foundation
import ReactorKit
import Domain
import RxSwift

public class FeedWithOptionReactor: Reactor{
    public enum Action{
        case fetchFeeds
        case refresh
        case deleteBookmark(Int)
        case deleteFeed(Int)
        case fetchOneOfFeeds(Int)
    }
    
    public enum Mutation{
        case setFeeds([FeedModel], Int)
        case addFeeds([FeedModel], Int)
        case setRefreshing(Bool)
        case setLoading(Bool)
        case removeFeed(Int)
        case updateBookmarkedWithPostId(Int)
        case deleteBookmark(Int)
        case changeOneOfFeeds(Int, FeedModel)
    }
    
    public struct State{
        var feeds: [FeedModel] = []
        var isRefreshing: Bool = false
        var isLoading: Bool = false
        var pageNumber: Int = 0
        var totalPages: Int = 1
        let feedOption: FeedOptionType
    }

    public let initialState: State
    private let feedUseCase: FeedUseCase
    
    public init(feedUseCase: FeedUseCase, feedOption: FeedOptionType){
        self.initialState = State(feedOption: feedOption)
        self.feedUseCase = feedUseCase
    }
    
    public func mutate(action: Action) -> Observable<Mutation> {
        switch action{
        case .fetchFeeds:
            guard !currentState.isLoading else { return .empty()}
            guard currentState.pageNumber < currentState.totalPages else { return .empty()}
            return Observable.concat([
                Observable.just(Mutation.setLoading(true)),
                self.feedUseCase.fetchOptionFeed(page: currentState.pageNumber, size: 20, option: currentState.feedOption).map{ Mutation.addFeeds($0.0, $0.1)},
                Observable.just(Mutation.setLoading(false))
            ])
        case .refresh:
            guard !currentState.isRefreshing else { return .empty()}
            
            return Observable.concat([
                Observable.just(Mutation.setRefreshing(true)),
                Observable.just(Mutation.setLoading(true)),
                feedUseCase.fetchOptionFeed(page: 0, size: 20, option: currentState.feedOption)
                    .map{ Mutation.setFeeds($0.0, $0.1)},
                Observable.just(Mutation.setLoading(false)),
                Observable.just(Mutation.setRefreshing(false)),
            ])
        case .deleteBookmark(let postId):
            return feedUseCase.deleteBookmark(postId: postId).map{_ in Mutation.deleteBookmark(postId) }
        case .deleteFeed(let postId):
            return Observable.just(Mutation.removeFeed(postId))
        case .fetchOneOfFeeds(let postId):
            return feedUseCase.fetchFeed(postId: postId).map{Mutation.changeOneOfFeeds(postId, $0)}
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
        case .removeFeed(let postId):
            newState.feeds.removeAll{ $0.postId == postId }
        case .deleteBookmark(let postId):
            if let index = newState.feeds.firstIndex(where: {
                $0.postId == postId
            }){
                newState.feeds.remove(at: index)
            }
        case .updateBookmarkedWithPostId(let postId):
            if let index = newState.feeds.firstIndex(where: {
                $0.postId == postId
            }){
                newState.feeds[index].isBookmarked = !newState.feeds[index].isBookmarked
            }
        case .changeOneOfFeeds(let postId, let feedModel):
            if let index = newState.feeds.firstIndex(where: {
                $0.postId == postId
            }){
                newState.feeds[index] = feedModel
            }
        }
        return newState
    }
}
