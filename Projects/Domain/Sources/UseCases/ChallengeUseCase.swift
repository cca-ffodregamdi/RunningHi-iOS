//
//  ChallengeUseCase.swift
//  Domain
//
//  Created by 유현진 on 5/29/24.
//

import Foundation
import RxSwift

public class ChallengeUseCase: ChallengeUseCaseProtocol{

    private let repository: ChallengeRepositoryProtocol
    
    public init(repository: ChallengeRepositoryProtocol) {
        self.repository = repository
    }
    
    public func fetchChallenge(status: ChallengeStatus) -> Observable<[ChallengeModel]> {
        return repository.fetchChallenge(status: status)
    }
    
    public func fetchMyChallenge(status: ChallengeStatus) -> Observable<[MyChallengeModel]> {
        return repository.fetchMyChallenge(status: status)
    }
    
    public func fetcOtherhChallengeDetail(challengeId: Int) -> Observable<OtherChallengeDetailModel> {
        return repository.fetcOtherhChallengeDetail(challengeId: challengeId)
    }
    
    public func fetchMyChallengeDetail(challengeId: Int) -> Observable<MyChallengeDetailModel> {
        return repository.fetchMyChallengeDetail(challengeId: challengeId)
    }
    
    public func joinChallenge(joinChallengeRequestModel: JoinChallengeRequestModel) -> Observable<Any> {
        return repository.joinChallenge(joinChallengeRequestModel: joinChallengeRequestModel)
    }
}
