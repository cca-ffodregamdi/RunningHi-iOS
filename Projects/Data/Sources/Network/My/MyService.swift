//
//  MyService.swift
//  Data
//
//  Created by 유현진 on 7/15/24.
//

import Foundation
import Moya
import RxSwift
import Domain

public enum MyService{
    case fetchNotice
}

extension MyService: TargetType{
    public var baseURL: URL {
        return .init(string: "https://runninghi.store/api/v1")!
    }
    
    public var accessToken: String{
        return UserDefaults.standard.object(forKey: "accessToken") as! String
    }
    
    public var path: String{
        switch self{
        case .fetchNotice: "/notices"
        }
    }
    
    public var method: Moya.Method{
        switch self{
        case .fetchNotice: .get
        }
    }
    
    public var task: Task{
        switch self{
        case .fetchNotice: .requestPlain
        }
    }
    
    public var headers: [String : String]?{
        switch self{
        case .fetchNotice:
            ["Content-type": "application/json",
                    "Authorization": accessToken]
        }
    }
}
