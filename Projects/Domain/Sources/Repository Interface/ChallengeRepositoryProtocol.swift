//
//  ChallengeRepositoryProtocol.swift
//  Domain
//
//  Created by 유현진 on 5/29/24.
//

import Foundation
import RxSwift
public protocol ChallengeRepositoryProtocol{
    func fetchChallenge(status: Bool) -> Observable<[ChallengeModel]>
    func fetchMyChallenge(status: Bool) -> Observable<[MyChallengeModel]>
    func getRank() -> Observable<[RankModel]>
}
