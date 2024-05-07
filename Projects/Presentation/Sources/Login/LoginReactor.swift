//
//  LoginReactor.swift
//  Presentation
//
//  Created by 유현진 on 5/4/24.
//

import Foundation
import RxSwift
import ReactorKit

final class LoginReactor: Reactor{
    public enum Action{
        case login
    }
    
    public enum Mutation{
        case login
        case setLoading(Bool)
    }
    
    public struct State{
        var testLogin: Bool
        var isLoading: Bool
        init() {
            testLogin = false
            isLoading = false
        }
    }
    
    public var initialState: State = State()
    
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action{
        case .login:
            return Observable.concat([
                Observable.just(Mutation.setLoading(true)),
                Observable.just(Mutation.login).delay(.milliseconds(500), scheduler: MainScheduler.instance),
                Observable.just(Mutation.setLoading(false))
            ])
            
        }
    }
    
    
    func reduce(state: State, mutation: Mutation) -> State {
        var state = state
        switch mutation{
        case .login:
            state.testLogin = true
        case .setLoading(let value):
            state.isLoading = value
        }
        return state
    }
}
