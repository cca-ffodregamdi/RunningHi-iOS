//
//  ChallengeDetailReactor.swift
//  Presentation
//
//  Created by 유현진 on 6/2/24.
//

import Foundation
import ReactorKit
import RxSwift
import Domain

public class ChallengeDetailReactor: Reactor{
    public enum Action{
        case fetchRank
    }
    
    public enum Mutation{
        case setRank([RankModel])
    }
    
    public struct State{
        var topRank: [RankModel] = []
        var otherRank: [RankModel] = []
    }
    
    public var initialState: State
    var challengeUseCase: ChallengeUseCase
    public init(challengeUseCase: ChallengeUseCase) {
        self.initialState = State()
        self.challengeUseCase = challengeUseCase
    }
    
    public func mutate(action: Action) -> Observable<Mutation> {
        switch action{
        case .fetchRank:
            return challengeUseCase.getRank()
                .map{ Mutation.setRank($0)}
        }
    }
    
    public func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        switch mutation{
        case .setRank(let models):
            let topRank = models.filter{$0.rank < 4}
            let otherRank = models.filter{$0.rank >= 4}
            newState.topRank = topRank
            newState.otherRank = otherRank
        }
        return newState
    }
}
