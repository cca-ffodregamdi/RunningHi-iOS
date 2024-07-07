//
//  RunningReactor.swift
//  Presentation
//
//  Created by najin on 7/7/24.
//

import Foundation
import ReactorKit
import Domain
import RxSwift

final public class RunningReactor: Reactor{
    
    //MARK: - Properties
    
    public let initialState: State
    private let runningUseCase: RunningUseCase
    
    private let timerSubject = PublishSubject<Void>()
    
    public enum Action{
        case readyForRunning
        case startRunning
        case pauseRunning
        case stopRunning
    }
    
    public enum Mutation{
        case setCountDown
        case setRunningTime
        case setPaused(Bool)
    }
    
    public struct State{
        var readyTime = 3
        var isRunning = false
        
        var runningTime = 0
        var runningPace = 0
        var runningCalorie = 0
        var runningDistance = 0
    }
    
    //MARK: - Lifecycle
    
    public init(runningUseCase: RunningUseCase){
        self.initialState = State()
        self.runningUseCase = runningUseCase
    }
    
    //MARK: - Configure
    
    public func mutate(action: Action) -> Observable<Mutation> {
        switch action{
        case .readyForRunning:
            return Observable<Int>.interval(.seconds(1), scheduler: MainScheduler.instance)
                .take(3)
                .map { _ in Mutation.setCountDown }
            
        case .startRunning:
            timerSubject.onNext(())
            return Observable.just(Mutation.setPaused(false))
                .observe(on:MainScheduler.asyncInstance)
            
        case .pauseRunning:
            return Observable.just(Mutation.setPaused(true))
            
        case .stopRunning:
            return Observable.just(Mutation.setPaused(true))
        }
    }
    
    public func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        switch mutation{
        case .setCountDown:
            newState.readyTime -= 1
            
            // Count Down 끝나면 러닝 시작
            if newState.readyTime == 0 {
                newState.isRunning = true
            }
            
        case let .setPaused(isPaused):
            newState.isRunning = !isPaused
            
        case .setRunningTime:
            newState.runningTime += 1
        }
        return newState
    }
    
    //MARK: - Helpers
    
    public func transform(mutation: Observable<Mutation>) -> Observable<Mutation> {
        let timerMutation = timerSubject
            .flatMapLatest { _ in
                Observable<Int>.interval(.seconds(1), scheduler: MainScheduler.instance)
                    .map { _ in Mutation.setRunningTime }
                    .take(until: self.action.filter {
                        if case .pauseRunning = $0 { return true }
                        return false
                    })
            }
        return Observable.merge(mutation, timerMutation)
    }
}
