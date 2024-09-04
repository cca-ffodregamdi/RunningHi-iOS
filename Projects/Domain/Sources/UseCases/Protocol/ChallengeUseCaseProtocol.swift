//
//  ChallengeProtocol.swift
//  Domain
//
//  Created by 유현진 on 5/29/24.
//

import Foundation
import RxSwift
protocol ChallengeUseCaseProtocol{
    func fetchChallenge(status: ChallengeStatus) -> Observable<[ChallengeModel]>
    func fetchMyChallenge(status: ChallengeStatus) -> Observable<[MyChallengeModel]>
    func fetcOtherhChallengeDetail(challengeId: Int) -> Observable<OtherChallengeDetailModel>
    func fetchMyChallengeDetail(challengeId: Int) -> Observable<MyChallengeDetailModel>
    func joinChallenge(joinChallengeRequestModel: JoinChallengeRequestDTO) -> Observable<Any>
}
