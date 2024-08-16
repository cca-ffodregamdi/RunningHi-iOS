//
//  RunningSettingReactor.swift
//  Presentation
//
//  Created by najin on 8/15/24.
//

import Foundation
import ReactorKit
import Domain
import RxSwift

final public class RunningSettingReactor: Reactor{
    
    //MARK: - Properties
    
    public let initialState: State
    
    public enum Action{
        case tapSettingTypeButton(RunningSettingType)
        case selectDistance(Int)
        case selectHour(Int)
        case selectMinute(Int)
    }
    
    public enum Mutation{
        case setSettingType(RunningSettingType)
        case setDistance(Int)
        case setHours(Int)
        case setMinutes(Int)
    }
    
    public struct State{
        var settingType: RunningSettingType = .distance
        var selectedDistance = 0
        var selectedHours = 0
        var selectedMinutes = 0
    }
    
    //MARK: - Lifecycle
    
    public init(){
        self.initialState = State()
    }
    
    //MARK: - Configure
    
    public func mutate(action: Action) -> Observable<Mutation> {
        switch action{
        case .tapSettingTypeButton(let type):
            return Observable.just(Mutation.setSettingType(type))
        case .selectDistance(let distance):
            return Observable.just(Mutation.setDistance(distance))
        case .selectHour(let hour):
            return Observable.just(Mutation.setHours(hour))
        case .selectMinute(let minute):
            return Observable.just(Mutation.setMinutes(minute))
        }
    }
    
    public func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        switch mutation{
        case .setSettingType(let type):
            newState.settingType = type
        case .setDistance(let distance):
            newState.selectedDistance = distance
        case .setHours(let hour):
            newState.selectedHours = hour
        case .setMinutes(let minute):
            newState.selectedMinutes = minute
        }
        return newState
    }
}
