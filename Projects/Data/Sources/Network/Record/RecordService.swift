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
}

extension RecordService: TargetType {
    public var baseURL: URL {
        return .init(string: "https://runninghi.store/api/v1")!
    }
    
    public var accessToken: String {
        return UserDefaults.standard.object(forKey: "accessToken") as! String
    }
    public var path: String {
        switch self {
        case .fetchRecord(let type, _):
            return "/records/\(type.rawValue)"
        }
    }
    
    public var method: Moya.Method {
        switch self {
        case .fetchRecord:
            return .get
        }
    }
    
    public var task: Moya.Task {
        switch self {
        case .fetchRecord(_, let date):
            return .requestParameters(parameters: ["date" : date], encoding: URLEncoding.queryString)
        }
    }
    
    public var headers: [String : String]? {
        return ["Content-type": "application/json",
                "Authorization": accessToken]
    }
}
