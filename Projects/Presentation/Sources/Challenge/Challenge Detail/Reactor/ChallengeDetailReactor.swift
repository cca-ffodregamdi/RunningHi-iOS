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
        case fetchChallengeInfo
        case joinChallenge(JoinChallengeRequestDTO)
    }
    
    public enum Mutation{
        case setOtherChallengeModel(OtherChallengeDetailModel)
        case setMyChallengeModel(MyChallengeDetailModel)
        case setFetched(Bool)
        case resetRank
    }
    
    public struct State{
        var challengeId: Int
        var isParticipated: Bool
        var isFetched = false
        var topRank: [RankModel] = []
        var otherRank: [RankModel] = []
        var myRank: RankModel?
        var myChallengeDetailModel: MyChallengeDetailModel?
        var otherChallengeDetailModel: OtherChallengeDetailModel?
    }
    
    public var initialState: State
    var challengeUseCase: ChallengeUseCase
    
    public init(challengeId: Int, isParticipated: Bool, challengeUseCase: ChallengeUseCase) {
        self.initialState = State(challengeId: challengeId, isParticipated: isParticipated)
        self.challengeUseCase = challengeUseCase
    }
    
    public func mutate(action: Action) -> Observable<Mutation> {
        switch action{
        case .fetchChallengeInfo:
            if currentState.isParticipated{
                return Observable.concat([
                    Observable.just(Mutation.setFetched(false)),
                    Observable.just(Mutation.resetRank),
                    challengeUseCase.fetchMyChallengeDetail(challengeId: currentState.challengeId).map{Mutation.setMyChallengeModel($0)},
                    Observable.just(Mutation.setFetched(true))
                ])
            }else{
                return Observable.concat([
                    Observable.just(Mutation.setFetched(false)),
                    Observable.just(Mutation.resetRank),
                    challengeUseCase.fetcOtherhChallengeDetail(challengeId: currentState.challengeId).map{Mutation.setOtherChallengeModel($0)},
                    Observable.just(Mutation.setFetched(true))
                ])
            }
        case .joinChallenge(let joinChallengeRequestModel):
            return Observable.concat([
                Observable.just(Mutation.setFetched(false)),
                challengeUseCase.joinChallenge(joinChallengeRequestModel: joinChallengeRequestModel).map{_ in Mutation.resetRank},
                challengeUseCase.fetchMyChallengeDetail(challengeId: currentState.challengeId).map{Mutation.setMyChallengeModel($0)},
                Observable.just(Mutation.setFetched(true))
            ])
        }
    }
    
    public func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        switch mutation{
        case .resetRank:
            newState.topRank = []
            newState.otherRank = []
            newState.myRank = nil
        case .setMyChallengeModel(let myChallengeModel):
            newState.myChallengeDetailModel = myChallengeModel
            let topRank = myChallengeModel.challengeRanking.filter{$0.rank < 4}
            let otherRank = myChallengeModel.challengeRanking.filter{$0.rank >= 4}
            newState.topRank = topRank
            newState.otherRank = otherRank
            newState.otherChallengeDetailModel = nil
            newState.isParticipated = true
        case .setOtherChallengeModel(let otherChallengeModel):
            newState.otherChallengeDetailModel = otherChallengeModel
            let topRank = otherChallengeModel.ranking.filter{$0.rank < 4}
            let otherRank = otherChallengeModel.ranking.filter{$0.rank >= 4}
            newState.topRank = topRank
            newState.otherRank = otherRank
            newState.myChallengeDetailModel = nil
            newState.isParticipated = false
        case .setFetched(let value):
            newState.isFetched = value
        }
        return newState
    }
}
