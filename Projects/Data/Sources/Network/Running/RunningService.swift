//
//  RunningService.swift
//  Data
//
//  Created by najin on 7/21/24.
//

import Foundation
import Moya
import RxSwift
import Domain

public enum RunningService {
    case saveRunningResult(data: RunningResultDTO)
}

extension RunningService: TargetType {
    public var baseURL: URL {
        return .init(string: "https://runninghi.store/api/v1")!
    }
    
    public var accessToken: String {
        return KeyChainManager.read(key: .runningHiAccessTokenkey)!
    }
    
    public var path: String {
        switch self {
        case .saveRunningResult:
            return "/posts/gpx"
        }
    }
    
    public var method: Moya.Method {
        switch self {
        case .saveRunningResult:
            return .post
        }
    }
    
    public var task: Moya.Task {
        switch self {
        case .saveRunningResult(let data):
            return .requestJSONEncodable(data)
        }
    }
    
    public var headers: [String : String]? {
        return ["Content-type": "application/json",
                "Authorization": accessToken]
    }
}
