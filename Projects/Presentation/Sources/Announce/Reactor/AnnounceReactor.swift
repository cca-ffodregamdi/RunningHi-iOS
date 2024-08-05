//
//  AnnounceReactor.swift
//  Presentation
//
//  Created by 유현진 on 8/5/24.
//

import Foundation
import RxSwift
import ReactorKit
import Domain

public class AnnounceReactor: Reactor{
    public enum Action{
        case fetchAnnounce
    }
    
    public enum Mutation{
        case setAnnouce([AnnounceModel])
    }
    
    public struct State{
        var announces: [AnnounceModel] = []
    }
    
    public var initialState: State
    private let announceUseCase: AnnounceUseCase
    
    public init(announceUseCase: AnnounceUseCase) {
        self.initialState = State()
        self.announceUseCase = announceUseCase
    }
    
    public func mutate(action: Action) -> Observable<Mutation> {
        switch action{
        case .fetchAnnounce: announceUseCase.fetchAnnounce().map{ Mutation.setAnnouce($0) }
        }
    }
    
    public func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        switch mutation{
        case .setAnnouce(let models):
            newState.announces = models
        }
        return newState
    }
}
