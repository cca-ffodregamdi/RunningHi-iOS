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
    
    public func getChallengeList() -> Observable<[ChallengeModel]> {
        return repository.getChallengeList()
    }
}
