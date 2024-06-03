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
import Data

class ChallengeDetailReactor: Reactor{
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
    
    var initialState: State
    var usecase: ChallengeUseCase
    public init() {
        self.initialState = State()
        usecase = .init(repository: ChallengeRepositoryImplementation())
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action{
        case .fetchRank:
            return usecase.getRank()
                .map{ Mutation.setRank($0)}
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
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
