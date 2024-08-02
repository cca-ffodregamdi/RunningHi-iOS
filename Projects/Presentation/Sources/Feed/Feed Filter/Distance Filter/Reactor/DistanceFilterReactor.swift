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
        case applyChangedValue(Float)
    }
    
    public enum Mutation{
        case updateValueChangedState(Bool)
        case resetValueChangeState(Bool)
        case updateDistanceState(DistanceFilter)
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
        case .changedValue: return Observable.just(Mutation.updateValueChangedState(true))
        case .reset: return Observable.just(Mutation.resetValueChangeState(false))
        case .applyChangedValue(let value):
            var newDistanceFilter: DistanceFilter
            switch value{
            case 0.0: newDistanceFilter = .around
            case 1.0: newDistanceFilter = .around5
            case 2.0: newDistanceFilter = .around10
            case 3.0: newDistanceFilter = .all
            default: return Observable.just(Mutation.updateDistanceState(currentState.distanceState))
            }
            return Observable.just(Mutation.updateDistanceState(newDistanceFilter))
        }
    }
    
    public func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        switch mutation{
        case .updateValueChangedState(let value):
            newState.valueChangedState = value
        case .resetValueChangeState(let value):
            newState.valueChangedState = value
        case .updateDistanceState(let state):
            newState.distanceState = state
        }
        return newState
    }
    
}
