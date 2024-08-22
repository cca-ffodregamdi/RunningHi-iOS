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
        case deleteAnnounce(announceId: Int, index: Int)
    }
    
    public enum Mutation{
        case setAnnouce([AnnounceModel])
        case deletedAnnounce(index: Int)
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
        case .deleteAnnounce(let announceId, let index): announceUseCase.deleteAnnounce(announceId: announceId).map{ _ in Mutation.deletedAnnounce(index: index)}
        }
    }
    
    public func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        switch mutation{
        case .setAnnouce(let models):
            newState.announces = models
        case .deletedAnnounce(let index):
            newState.announces.remove(at: index)
        }
        return newState
    }
}
