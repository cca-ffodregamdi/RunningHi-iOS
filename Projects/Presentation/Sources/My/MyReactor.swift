//
//  MyReactor.swift
//  Presentation
//
//  Created by 유현진 on 5/19/24.
//

import Foundation
import ReactorKit
import RxDataSources

final public class MyReactor: Reactor{
    
    public enum Action{
        case load
    }
    
    public enum Mutation{
        case setSections([MyPageItem])
    }
    
    public struct State{
        var items: [MyPageItem] = []
    }
    
    public var initialState: State
    
    public init(){
        self.initialState = State()
    }
    
    public func mutate(action: Action) -> Observable<Mutation> {
        switch action{
        case .load:
            let items: [MyPageItem] = [
                .notices,
                .myFeed,
                .feedback,
            ]
            return .just(.setSections(items))
        }
    }
    
    public func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        switch mutation{
        case .setSections(let sections):
            newState.items = sections
            
        }
        return newState
    }
    
}
