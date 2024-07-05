//
//  ChallengeService.swift
//  Data
//
//  Created by 유현진 on 5/29/24.
//

import Foundation
import Moya
import RxSwift

public enum ChallengeService{
    case fetchChallenge(status: Bool)
    case fetchMyChallenge(status: Bool)
    case fetchOtherChallengeDetail(challengeId: Int)
    case fetchMyChallengeDetail(challengeId: Int)
}

extension ChallengeService: TargetType{
    
    public var baseURL: URL {
        return .init(string: "https://runninghi.store/api/v1")!
    }
    
    public var accessToken: String{
        return UserDefaults.standard.object(forKey: "accessToken") as! String
    }
    
    public var path: String{
        switch self{
        case .fetchChallenge: "/challenges/status"
        case .fetchMyChallenge: "/challenges/my-challenge/status"
        case .fetchOtherChallengeDetail(let challengeId): "/challenges/\(challengeId)"
        case .fetchMyChallengeDetail(let challengeId): "/challenges/my-challenge/\(challengeId)"
        }
    }
    
    public var method: Moya.Method{
        switch self{
        case .fetchChallenge,
                .fetchMyChallenge,
                .fetchOtherChallengeDetail,
                .fetchMyChallengeDetail: .get
        
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
        }
    }
    
    public var headers: [String : String]?{
        switch self{
        case .fetchChallenge,
                .fetchMyChallenge,
                .fetchOtherChallengeDetail,
                .fetchMyChallengeDetail:
            ["Content-type": "application/json",
                    "Authorization": accessToken]
        }
    }
}
