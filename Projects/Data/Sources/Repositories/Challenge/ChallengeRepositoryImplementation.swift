//
//  ChallengeRepositoryImplementation.swift
//  Data
//
//  Created by 유현진 on 5/29/24.
//

import Foundation
import Domain
import RxSwift

public final class ChallengeRepositoryImplementation: ChallengeRepositoryProtocol{
    
    public init() { }
    
    public func getChallengeList() -> Observable<[ChallengeModel]> {
        return Observable.just([
            ChallengeModel(title: "첫번째 챌린지", distance: 10, memberCount: 100, isParticipating: true),
            ChallengeModel(title: "두번째 챌린지", distance: 10, memberCount: 100, isParticipating: false),
            ChallengeModel(title: "세번째 챌린지", distance: 10, memberCount: 100, isParticipating: true),
            ChallengeModel(title: "네번째 챌린지", distance: 10, memberCount: 100, isParticipating: false),
            ChallengeModel(title: "다섯번째 챌린지", distance: 10, memberCount: 100, isParticipating: true),
            ChallengeModel(title: "여섯번째 챌린지", distance: 10, memberCount: 100, isParticipating: false)])
    }
}
