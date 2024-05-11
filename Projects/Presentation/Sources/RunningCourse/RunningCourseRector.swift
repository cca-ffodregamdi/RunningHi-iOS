//
//  RunningCourseRector.swift
//  Presentation
//
//  Created by 오영석 on 5/11/24.
//

import Foundation
import ReactorKit
import RxSwift

final class RunningCourseRector: Reactor {
    enum Action {
        case centerMapOnUser
    }
    
    enum Mutation {
        case setMapCentering(Bool)
    }
    
    struct State {
        var isCentering: Bool
    }
    
    var initialState: State = State(isCentering: false)
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .centerMapOnUser:
            return Observable.just(Mutation.setMapCentering(true))
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        switch mutation {
        case .setMapCentering(let isCentering):
            newState.isCentering = isCentering
        }
        return newState
    }
}
