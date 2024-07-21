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
        case saveRunningRecord(RunningResult)
    }
    
    public enum Mutation{
        case setDifficultyLevel(Int)
        case setLoading(Bool)
        case completeSaveResult
    }
    
    public struct State{
        var isLoading = false
        var isSaveCompleted = false
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
        case .tapDifficultyButton(let difficulty):
            return Observable.just(Mutation.setDifficultyLevel(difficulty))
        
        case .saveRunningRecord(let runningResult):
            guard !currentState.isLoading else { return .empty()}
            return Observable.concat([
                Observable.just(Mutation.setLoading(true)),
                runningUseCase.saveRunningResult(runningResult: runningResult).map { _ in Mutation.completeSaveResult }
                    .catch { error in
                        print("errororororororororor \(error)")
                        return Observable.concat([
                            Observable.just(Mutation.setLoading(false))
                        ])
                    }
            ])
        }
    }
    
    public func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        switch mutation{
        
        case .setDifficultyLevel(let difficulty):
            newState.difficultyLevel = difficulty
        
        case .setLoading(let value):
            newState.isLoading = value
        
        case .completeSaveResult:
            newState.isLoading = false
            newState.isSaveCompleted = true
        }
        return newState
    }
}
