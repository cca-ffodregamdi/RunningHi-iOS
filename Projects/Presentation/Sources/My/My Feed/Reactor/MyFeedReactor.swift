//
//  MyFeedReactor.swift
//  Presentation
//
//  Created by 유현진 on 8/20/24.
//

import Foundation
import RxSwift
import ReactorKit
import Domain

public class MyFeedReactor: Reactor{
    public enum Action{
        case fetchMyFeeds
        case refresh
        case makeBookmark(BookmarkRequestDTO, Int)
        case deleteBookmark(Int, Int)
        case deleteFeed(Int)
    }
    
    public enum Mutation{
        case setFeeds([FeedModel], Int)
        case addFeeds([FeedModel], Int)
        case setRefreshing(Bool)
        case setLoading(Bool)
        case updateBookmarked(Int, Bool)
        case removeFeed(Int)
    }
    
    public struct State{
        var feeds: [FeedModel] = []
        var isRefreshing: Bool = false
        var isLoading: Bool = false
        var pageNumber: Int = 0
        var totalPages: Int = 1
    }

    public let initialState: State
    private let myUseCase: MyUseCase
    
    public init(myUseCase: MyUseCase){
        self.initialState = State()
        self.myUseCase = myUseCase
    }
    
    public func mutate(action: Action) -> Observable<Mutation> {
        switch action{
        case .fetchMyFeeds:
            guard !currentState.isLoading else { return .empty()}
            guard currentState.pageNumber < currentState.totalPages else { return .empty()}
            return Observable.concat([
                Observable.just(Mutation.setLoading(true)),
                self.myUseCase.fetchMyFeed(page: currentState.pageNumber, size: 20).map{ Mutation.addFeeds($0.0, $0.1)},
                Observable.just(Mutation.setLoading(false))
            ])
        case .refresh:
            guard !currentState.isRefreshing else { return .empty()}
            
            return Observable.concat([
                Observable.just(Mutation.setRefreshing(true)),
                Observable.just(Mutation.setLoading(true)),
                myUseCase.fetchMyFeed(page: 0, size: 20)
                    .map{ Mutation.setFeeds($0.0, $0.1)},
                Observable.just(Mutation.setLoading(false)),
                Observable.just(Mutation.setRefreshing(false)),
            ])
        case .makeBookmark(let bookmarkRequest, let index):
            return myUseCase.makeBookmark(post: bookmarkRequest).map{ _ in Mutation.updateBookmarked(index, true) }
        case .deleteBookmark(let postId, let index):
            return myUseCase.deleteBookmark(postId: postId).map{_ in Mutation.updateBookmarked(index, false) }
        case .deleteFeed(let postId):
            return Observable.just(Mutation.removeFeed(postId))
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
        case .updateBookmarked(let index, let isBookmarked):
            newState.feeds[index].isBookmarked = isBookmarked
        case .removeFeed(let postId):
            newState.feeds.removeAll{ $0.postId == postId }
        }
        return newState
    }
}
