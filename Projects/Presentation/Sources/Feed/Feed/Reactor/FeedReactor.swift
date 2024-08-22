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
        case makeBookmark(BookmarkRequestDTO, Int)
        case deleteBookmark(Int, Int)
        case deleteFeed(Int)
        case updateSortFilter(SortFilter)
        case updateDistanceFilter(DistanceFilter)
    }
    
    public enum Mutation{
        case setFeeds([FeedModel], Int)
        case addFeeds([FeedModel], Int)
        case setRefreshing(Bool)
        case setLoading(Bool)
        case updateBookmarked(Int, Bool)
        case removeFeed(Int)
        case setSortFilter(SortFilter)
        case setDistanceFilter(DistanceFilter)
    }
    
    public struct State{
        var feeds: [FeedModel] = []
        var isRefreshing: Bool = false
        var isLoading: Bool = false
        var pageNumber: Int = 0
        var totalPages: Int = 1
        var sortState: SortFilter = .latest
        var distanceState: DistanceFilter = .all
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
                self.feedUseCase.fetchFeeds(page: currentState.pageNumber, size: 20, sort: currentState.sortState.rawValue, distance: currentState.distanceState.value).map{ Mutation.addFeeds($0.0, $0.1)},
                Observable.just(Mutation.setLoading(false))
            ])
        case .refresh:
            guard !currentState.isRefreshing else { return .empty()}
            
            return Observable.concat([
                Observable.just(Mutation.setRefreshing(true)),
                Observable.just(Mutation.setLoading(true)),
                self.feedUseCase.fetchFeeds(page: currentState.pageNumber, size: 20, sort: currentState.sortState.rawValue, distance: currentState.distanceState.value)
                    .map{ Mutation.setFeeds($0.0, $0.1)},
                Observable.just(Mutation.setLoading(false)),
                Observable.just(Mutation.setRefreshing(false)),
            ])
        case .makeBookmark(let bookmarkRequest, let index):
            return feedUseCase.makeBookmark(post: bookmarkRequest).map{ _ in Mutation.updateBookmarked(index, true) }
        case .deleteBookmark(let postId, let index):
            return feedUseCase.deleteBookmark(postId: postId).map{_ in Mutation.updateBookmarked(index, false) }
        case .deleteFeed(let postId):
            return Observable.just(Mutation.removeFeed(postId))
        case .updateSortFilter(let sort):
            return Observable.just(Mutation.setSortFilter(sort))
        case .updateDistanceFilter(let distance):
            return Observable.just(Mutation.setDistanceFilter(distance))
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
        case .setSortFilter(let sort):
            newState.sortState = sort
        case .setDistanceFilter(let distance):
            newState.distanceState = distance
        }
        return newState
    }
}
