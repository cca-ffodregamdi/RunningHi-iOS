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
    
    public func fetchChallenge(status: Bool) -> Observable<[ChallengeModel]> {
        return repository.fetchChallenge(status: status)
    }
    
    public func fetchMyChallenge(status: Bool) -> Observable<[MyChallengeModel]> {
        return repository.fetchMyChallenge(status: status)
    }
    
    public func getChallengeList() -> Observable<[ChallengeModel]> {
        return repository.getChallengeList()
    }
    
    public func getRank() -> Observable<[RankModel]> {
        return repository.getRank()
    }
}
