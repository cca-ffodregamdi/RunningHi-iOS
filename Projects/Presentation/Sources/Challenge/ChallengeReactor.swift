//
//  ChallengeReactor.swift
//  Presentation
//
//  Created by 유현진 on 5/29/24.
//

import Foundation
import ReactorKit
import RxSwift
import Domain
import Data

public class ChallengeReactor: Reactor{
    public enum Action{
        case fetchChallenge
    }
    
    public enum Mutation{
        case setChallenge([ChallengeModel])
    }
    
    public struct State{
        var section: [ChallengeSection] = []
    }
    
    public var initialState: State
    private let challengeUseCase: ChallengeUseCase
    
    public init(challengeUseCase: ChallengeUseCase) {
        self.initialState = State()
        self.challengeUseCase = challengeUseCase
    }
    
    public func mutate(action: Action) -> Observable<Mutation> {
        switch action{
        case .fetchChallenge: 
            return self.challengeUseCase.getChallengeList()
                .map{ Mutation.setChallenge($0) }
        }
    }
    
    public func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        switch mutation{
        case .setChallenge(let challenges):
            let participating = challenges.filter{$0.isParticipating}
            let notParticipating = challenges.filter{ !$0.isParticipating }
            newState.section = [
                .participating(participating),
                .notParticipaing(notParticipating)
            ]
        }
        return newState
    }
}
