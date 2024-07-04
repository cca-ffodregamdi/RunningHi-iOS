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
        }
    }
    
    public var method: Moya.Method{
        switch self{
        case .fetchChallenge,
                .fetchMyChallenge: .get
        
        }
    }
    
    public var task: Task{
        switch self{
        case .fetchChallenge(let status):
                .requestParameters(parameters: ["status" : status], encoding: URLEncoding.queryString)
        case .fetchMyChallenge(let status):
                .requestParameters(parameters: ["status" : status], encoding: URLEncoding.queryString)
        }
    }
    
    public var headers: [String : String]?{
        switch self{
        case .fetchChallenge,
                .fetchMyChallenge:
            ["Content-type": "application/json",
                    "Authorization": accessToken]
        }
    }
}
