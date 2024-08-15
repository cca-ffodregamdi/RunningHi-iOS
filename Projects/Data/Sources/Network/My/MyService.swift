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
    case fetchFAQ
    case fetchFeedback
}

extension MyService: TargetType{
    public var baseURL: URL {
        return .init(string: "https://runninghi.store/api/v1")!
    }
    
    public var accessToken: String{
        return KeyChainManager.read(key: .runningHiAccessTokenkey)!
    }
    
    public var path: String{
        switch self{
        case .fetchNotice: "/notices"
        case .fetchFAQ: "/faq"
        case .fetchFeedback: "/feedbacks"
        }
    }
    
    public var method: Moya.Method{
        switch self{
        case .fetchNotice, .fetchFAQ, .fetchFeedback: .get
        }
    }
    
    public var task: Task{
        switch self{
        case .fetchNotice, .fetchFAQ, .fetchFeedback: .requestPlain
        }
    }
    
    public var headers: [String : String]?{
        switch self{
        case .fetchNotice, .fetchFAQ, .fetchFeedback:
            ["Content-type": "application/json",
                    "Authorization": accessToken]
        }
    }
}
