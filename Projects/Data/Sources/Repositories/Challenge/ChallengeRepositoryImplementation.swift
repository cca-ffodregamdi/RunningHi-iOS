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
    
    public func getRank() -> Observable<[RankModel]> {
        return Observable.just([
            RankModel(rank: 1, nickName: "닉네임", distance: 8),
            RankModel(rank: 2, nickName: "닉네임", distance: 8),
            RankModel(rank: 3, nickName: "닉네임", distance: 8),
            RankModel(rank: 4, nickName: "닉네임", distance: 8),
            RankModel(rank: 5, nickName: "닉네임", distance: 8),
            RankModel(rank: 6, nickName: "닉네임", distance: 8),
            RankModel(rank: 7, nickName: "닉네임", distance: 8),
            RankModel(rank: 8, nickName: "닉네임", distance: 8),
            RankModel(rank: 9, nickName: "닉네임", distance: 8),
            RankModel(rank: 10, nickName: "닉네임", distance: 8),
            RankModel(rank: 11, nickName: "닉네임", distance: 8)
        ])
    }
}
