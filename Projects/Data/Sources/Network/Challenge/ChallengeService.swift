//
//  ChallengeService.swift
//  Data
//
//  Created by 유현진 on 5/29/24.
//

import Foundation
import Moya
import RxSwift
import Domain

public enum ChallengeService{
    case fetchChallenge(status: ChallengeStatus)
    case fetchMyChallenge(status: ChallengeStatus)
    case fetchOtherChallengeDetail(challengeId: Int)
    case fetchMyChallengeDetail(challengeId: Int)
    case joinChallenge(joinChallengeRequestModel: JoinChallengeRequestModel)
}

extension ChallengeService: TargetType{
    
    public var baseURL: URL {
        return .init(string: "https://runninghi.store/api/v1")!
    }
    
    public var accessToken: String{
        return KeyChainManager.read(key: .runningHiAccessTokenkey)!
    }
    
    public var path: String{
        switch self{
        case .fetchChallenge: "/challenges/status"
        case .fetchMyChallenge: "/challenges/my-challenge/status"
        case .fetchOtherChallengeDetail(let challengeId): "/challenges/\(challengeId)"
        case .fetchMyChallengeDetail(let challengeId): "/challenges/my-challenge/\(challengeId)"
        case .joinChallenge: "/challenges/my-challenge"
        }
    }
    
    public var method: Moya.Method{
        switch self{
        case .fetchChallenge,
                .fetchMyChallenge,
                .fetchOtherChallengeDetail,
                .fetchMyChallengeDetail: .get
        case .joinChallenge:
                .post
        }
    }
    
    public var task: Task{
        switch self{
        case .fetchChallenge(let status):
                .requestParameters(parameters: ["status" : status], encoding: URLEncoding.queryString)
        case .fetchMyChallenge(let status):
                .requestParameters(parameters: ["status" : status], encoding: URLEncoding.queryString)
        case .fetchOtherChallengeDetail:
                .requestPlain
        case .fetchMyChallengeDetail:
                .requestPlain
        case .joinChallenge(let joinChallengeRequestModel):
                .requestJSONEncodable(joinChallengeRequestModel)
        }
    }
    
    public var headers: [String : String]?{
        switch self{
        case .fetchChallenge,
                .fetchMyChallenge,
                .fetchOtherChallengeDetail,
                .fetchMyChallengeDetail,
                .joinChallenge:
            ["Content-type": "application/json",
                    "Authorization": accessToken]
        }
    }
}
