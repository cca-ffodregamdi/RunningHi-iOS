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
                return challengeResponse.data.challengeList
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
                return myChallengeResponse.data.myChallengeList
            }.asObservable()
            .catch{ error in
                print("ChallengeRepositoryImplementation fetchMyChallenge decoding error: \(error)")
                return Observable.error(error)
            }
    }
    
    public func fetcOtherhChallengeDetail(challengeId: Int) -> Observable<OtherChallengeDetailModel> {
        return service.rx.request(.fetchOtherChallengeDetail(challengeId: challengeId))
            .filterSuccessfulStatusCodes()
            .map{ response -> OtherChallengeDetailModel in
                let otherChallengeResponse = try JSONDecoder().decode(OtherChallengeDetailResponseDTO.self, from: response.data)
                return otherChallengeResponse.data
            }.asObservable()
            .catch { error in
                print("ChallengeRepositoryImplementation fetcOtherhChallengeDetail decoding error: \(error)")
                return Observable.error(error)
            }
    }
    
    public func fetchMyChallengeDetail(challengeId: Int) -> Observable<MyChallengeDetailModel> {
        return service.rx.request(.fetchMyChallengeDetail(challengeId: challengeId))
            .filterSuccessfulStatusCodes()
            .map{ response -> MyChallengeDetailModel in
                let myChallengeResponse = try JSONDecoder().decode(MyChallengeDetailResponseDTO.self, from: response.data)
                return myChallengeResponse.data
            }.asObservable()
            .catch { error in
                print("ChallengeRepositoryImplementation fetchMyChallengeDetail decoding error: \(error)")
                return Observable.error(error)
            }
    }
    
    public func joinChallenge(joinChallengeRequestModel: JoinChallengeRequestDTO) -> Observable<Any> {
        return service.rx.request(.joinChallenge(joinChallengeRequestModel: joinChallengeRequestModel))
            .filterSuccessfulStatusCodes()
            .map{ _ in
                return Observable.just(())
            }.asObservable()
    }
}
