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
    private var backgroundEntryTime: Date?
    
    public enum Action{
        case checkAuthorization
        case readyForRunning
        case startRunning
        case pauseRunning
        case stopRunning
        
        case didEnterBackground
        case didEnterForeground
    }
    
    public enum Mutation{
        case setAuthorization(LocationAuthorizationStatus?)
        case setCountDown
        case setRunningTime
        case setCurrentLocation(RouteInfo)
        case setPaused(Bool)
        case setElapsedSeconds
    }
    
    public struct State{
        var authorization: LocationAuthorizationStatus?
        var readyTime = 3
        var isRunning = false
        
        var currentLocation: RouteInfo?
        
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
        case .checkAuthorization:
            return runningUseCase.checkUserCurrentLocationAuthorization()
                .map { status in Mutation.setAuthorization(status) }
                
        case .readyForRunning:
            return Observable<Int>.interval(.seconds(1), scheduler: MainScheduler.instance)
                .take(3)
                .map { _ in Mutation.setCountDown }
            
        case .startRunning:
            timerSubject.onNext(())
            runningUseCase.startRunning()
            return Observable.just(Mutation.setPaused(false))
                .observe(on:MainScheduler.asyncInstance)
            
        case .pauseRunning, .stopRunning:
            runningUseCase.stopRunning()
            return Observable.just(Mutation.setPaused(true))
        
        case .didEnterBackground:
            backgroundEntryTime = Date()
            return Observable.empty()
            
        case .didEnterForeground:
            return Observable.just(Mutation.setElapsedSeconds)
        }
    }
    
    public func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        switch mutation{
        case .setAuthorization(let status):
            newState.authorization = status
            
        case .setCountDown:
            newState.readyTime -= 1
            
            // Count Down 끝나면 러닝 시작
            if newState.readyTime == 0 {
                newState.isRunning = true
            }
            
        case .setPaused(let isPaused):
            newState.isRunning = !isPaused
            
        case .setRunningTime:
            newState.runningTime += 1
            
        case .setCurrentLocation(let location):
            if state.isRunning {
                newState.currentLocation = location
            }
            
        case .setElapsedSeconds:
            if state.isRunning {
                if let backgroundEntryTime = self.backgroundEntryTime {
                    newState.runningTime += Int(Date().timeIntervalSince(backgroundEntryTime))
                    self.backgroundEntryTime = nil
                    timerSubject.onNext(())
                }
            }
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
                        guard let _ = self.backgroundEntryTime else { return true }
                        return false
                    })
            }
        
        let runningMutation = runningUseCase.getUserLocation()
            .flatMapLatest { location in
                Observable.just(Mutation.setCurrentLocation(location))
            }
        
        return Observable.merge(mutation, timerMutation, runningMutation)
    }
}
