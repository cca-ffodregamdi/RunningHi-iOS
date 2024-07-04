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

public class ChallengeReactor: Reactor{
    public enum Action{
        case fetchChallenge
        case fetchMyChallenge
    }
    
    public enum Mutation{
        case setTotalChallenge([ChallengeModel])
        case setMyChallenge([MyChallengeModel])
    }
    
    public struct State{
        var totalChallenges: [ChallengeModel] = []
        var myChallenges: [MyChallengeModel] = []
        var section: [ChallengeSectionModel] {
            let myChallengeItems = myChallenges.map{ChallengeItem.participating($0)}
            let challengeItems = totalChallenges.map { ChallengeItem.notParticipaing($0) }
            
            let myChallengeSection = ChallengeSectionModel(header: "참여 중인 챌린지", items: myChallengeItems)
            let challengeSection = ChallengeSectionModel(header: "진행 중인 챌린지", items: challengeItems)
            
            return [myChallengeSection, challengeSection]
        }
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
            return self.challengeUseCase.fetchChallenge(status: true)
                .map{ Mutation.setTotalChallenge($0) }
            
        case .fetchMyChallenge:
            return challengeUseCase.fetchMyChallenge(status: true).map{ Mutation.setMyChallenge($0)}
        }
    }
    
    public func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        switch mutation{
        case .setTotalChallenge(let challenges):
            newState.totalChallenges = challenges
        case .setMyChallenge(let challenges):
            newState.myChallenges = challenges
        }
        return newState
    }
}
