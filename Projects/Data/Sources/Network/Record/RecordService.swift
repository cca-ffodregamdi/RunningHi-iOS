//
//  RecordService.swift
//  Data
//
//  Created by najin on 7/28/24.
//

import Foundation
import Moya
import RxSwift
import Domain

public enum RecordService {
    case fetchRecord(type: RecordChartType, date: String)
    case fetchRunning(postNo: Int)
    case fetchGPSData(url: String)
    case deleteRecord(postNo: Int)
}

extension RecordService: TargetType {
    public var baseURL: URL {
        switch self {
        case .fetchGPSData(let url):
            return .init(string: url)!
        default:
            return .init(string: "https://runninghi.store/api/v1")!
        }
    }
    
    public var accessToken: String {
        return KeyChainManager.read(key: .runningHiAccessTokenkey)!
    }
    
    public var path: String {
        switch self {
        case .fetchRecord(let type, _):
            return "/records/\(type.rawValue)"
        case .fetchRunning(let postNo), .deleteRecord(let postNo):
            return "posts/\(postNo)"
        case .fetchGPSData:
            return ""
        }
    }
    
    public var method: Moya.Method {
        switch self {
        case .fetchRecord, .fetchRunning, .fetchGPSData:
            return .get
        case .deleteRecord(postNo: let postNo):
            return .delete
        }
    }
    
    public var task: Moya.Task {
        switch self {
        case .fetchRecord(_, let date):
            return .requestParameters(parameters: ["date" : date], encoding: URLEncoding.queryString)
        case .fetchRunning, .fetchGPSData, .deleteRecord:
            return .requestPlain
        }
    }
    
    public var headers: [String : String]? {
        
        switch self {
        case .fetchGPSData:
            return nil
        default:
            return ["Content-type": "application/json",
                    "Authorization": accessToken]
        }
    }
}
