//
//  TabBarService.swift
//  Data
//
//  Created by 유현진 on 9/27/24.
//

import Foundation
import Moya
import RxSwift
import Domain

public enum TabBarService{
    case uploadFCMToken(String)
}

extension TabBarService: TargetType{
    public var baseURL: URL {
        return .init(string: "https://runninghi.store/api/v1")!
    }
    
    public var accessToken: String{
        return KeyChainManager.read(key: .runningHiAccessTokenkey)!
    }
    
    public var path: String{
        switch self{
        case .uploadFCMToken: "/member/fcmToken/1"
        }
    }
    
    public var method: Moya.Method{
        switch self{
        case .uploadFCMToken: .put
        }
    }
    
    public var task: Task{
        switch self{
        case .uploadFCMToken: .requestPlain
        }
    }
    
    public var headers: [String : String]?{
        switch self{
        case .uploadFCMToken(let fcmToken):
                
            ["Content-type": "application/json",
                    "FcmToken": fcmToken,
             "Authorization": accessToken]
        }
    }
}
