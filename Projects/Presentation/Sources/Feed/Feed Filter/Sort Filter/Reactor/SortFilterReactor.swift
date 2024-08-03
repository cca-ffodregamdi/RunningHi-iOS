//
//  SortFilterReactor.swift
//  Presentation
//
//  Created by 유현진 on 8/2/24.
//

import Foundation
import RxSwift
import ReactorKit

public class SortFilterReactor: Reactor{
    public enum Action{
        case seletedSortIndex(Int)
    }
    
    public enum Mutation{
        case updatedSort(SortFilter)
    }
    
    public struct State{
        let sortList: [SortFilter] = [.latest, .recommended, .like, .distance]
        var sortState: SortFilter
        var updatedState: Bool = false
    }
    
    public var initialState: State
    
    public init(sortFilter: SortFilter) {
        self.initialState = State(sortState: sortFilter)
    }
    
    public func mutate(action: Action) -> Observable<Mutation> {
        switch action{
        case .seletedSortIndex(let index):
            Observable.just(Mutation.updatedSort(currentState.sortList[index]))
        }
    }
    
    public func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        switch mutation{
        case .updatedSort(let sortState):
            newState.sortState = sortState
            newState.updatedState = true
        }
        return newState
    }
}
