//
//  ChallengeRepositoryImplementation.swift
//  Data
//
//  Created by 유현진 on 5/29/24.
//

import Foundation
import Domain
import RxSwift
import Moya
import RxMoya

public final class ChallengeRepositoryImplementation: ChallengeRepositoryProtocol{
    
    private let service = MoyaProvider<ChallengeService>()
    
    public init() { }
    
    public func fetchChallenge(status: Bool) -> Observable<[ChallengeModel]> {
        return service.rx.request(.fetchChallenge(status: status))
            .filterSuccessfulStatusCodes()
            .map{ response -> [ChallengeModel] in
                let challengeResponse = try JSONDecoder().decode(ChallengeResponseDTO.self, from: response.data)
                return challengeResponse.data
            }.asObservable()
            .catch{ error in
                print("ChallengeRepositoryImplementation fetchChallenge decoding error: \(error)")
                return Observable.error(error)
            }
            
    }
    
    public func fetchMyChallenge(status: Bool) -> Observable<[MyChallengeModel]> {
        return service.rx.request(.fetchMyChallenge(status: status))
            .filterSuccessfulStatusCodes()
            .map{ response -> [MyChallengeModel] in
                let myChallengeResponse = try JSONDecoder().decode(MyChallengeResponseDTO.self, from: response.data)
                return myChallengeResponse.data
            }.asObservable()
            .catch{ error in
                print("ChallengeRepositoryImplementation fetchMyChallenge decoding error: \(error)")
                return Observable.error(error)
            }
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
