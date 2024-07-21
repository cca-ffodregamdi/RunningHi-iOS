//
//  RunningResultReactor.swift
//  Presentation
//
//  Created by najin on 7/20/24.
//

import Foundation
import ReactorKit
import Domain
import RxSwift

final public class RunningResultReactor: Reactor {
    
    //MARK: - Properties
    
    public let initialState: State
    private let runningUseCase: RunningUseCase
    
    public enum Action{
        case tapDifficultyButton(Int)
    }
    
    public enum Mutation{
        case setDifficultyLevel(Int)
    }
    
    public struct State{
        var difficultyLevel = 0
    }
    
    //MARK: - Lifecycle
    
    public init(runningUseCase: RunningUseCase){
        self.initialState = State()
        self.runningUseCase = runningUseCase
    }
    
    //MARK: - Configure
    
    public func mutate(action: Action) -> Observable<Mutation> {
        switch action{
        case let .tapDifficultyButton(difficulty):
            return Observable.just(Mutation.setDifficultyLevel(difficulty))
        }
    }
    
    public func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        switch mutation{
        case let .setDifficultyLevel(difficulty):
            newState.difficultyLevel = difficulty
        }
        return newState
    }
}
