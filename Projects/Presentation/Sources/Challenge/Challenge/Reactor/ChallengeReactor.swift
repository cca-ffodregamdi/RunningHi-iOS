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
import Common

public class ChallengeReactor: Reactor{
    public enum Action{
        case fetchChallengeSection
    }
    
    public enum Mutation{
        case setChallengeSection([ChallengeModel], [MyChallengeModel], [MyChallengeModel])
    }
    
    public struct State{
        var section: [ChallengeSectionModel] = []
    }
    
    public var initialState: State
    private let challengeUseCase: ChallengeUseCase
    
    public init(challengeUseCase: ChallengeUseCase) {
        self.initialState = State()
        self.challengeUseCase = challengeUseCase
    }
    
    public func mutate(action: Action) -> Observable<Mutation> {
        switch action{
        case .fetchChallengeSection:
            return Observable.zip(challengeUseCase.fetchChallenge(status: .IN_PROGRESS),
                                  challengeUseCase.fetchMyChallenge(status: .IN_PROGRESS),
                                  challengeUseCase.fetchMyChallenge(status: .COMPLETED))
            .map{Mutation.setChallengeSection($0, $1, $2)}
            
        }
    }
    
    public func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        switch mutation{
        case .setChallengeSection(let notParticipating, let participating, let completed):
            let notParticipatingSection = ChallengeSectionModel(header: "\(Date.getCurrentMonth())월의 챌린지", items: notParticipating.map{ChallengeItem.notParticipating($0)})
            let participatingSection = ChallengeSectionModel(header: "참여 중인 챌린지", items: participating.map{ChallengeItem.participating($0)})
            let completedSection = ChallengeSectionModel(header: "완료한 챌린지", items: completed.map{ChallengeItem.completed($0)})
            newState.section = [participatingSection, notParticipatingSection, completedSection]
        }
        return newState
    }
}
