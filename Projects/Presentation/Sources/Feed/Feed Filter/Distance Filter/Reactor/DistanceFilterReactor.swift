//
//  DistanceFilterReactor.swift
//  Presentation
//
//  Created by 유현진 on 8/1/24.
//

import Foundation
import ReactorKit
import RxSwift

public class DistanceFilterReactor: Reactor{
    public enum Action{
        case changedValue
        case reset
    }
    
    public enum Mutation{
        case updateValueChangedState(Bool)
        case resetValueChangeState(Bool)
    }
    
    public struct State{
        var distanceState: DistanceFilter
        var valueChangedState: Bool = false
    }
    
    public var initialState: State
    
    public init(distanceState: DistanceFilter) {
        self.initialState = State(distanceState: distanceState)
    }
    
    public func mutate(action: Action) -> Observable<Mutation> {
        switch action{
        case .changedValue: Observable.just(Mutation.updateValueChangedState(true))
        case .reset: Observable.just(Mutation.resetValueChangeState(false))
        }
    }
    
    public func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        switch mutation{
        case .updateValueChangedState(let value):
            newState.valueChangedState = value
        case .resetValueChangeState(let value):
            newState.valueChangedState = value
        }
        return newState
    }
    
}
