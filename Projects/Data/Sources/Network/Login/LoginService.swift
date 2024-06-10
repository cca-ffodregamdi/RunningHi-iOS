//
//  LoginService.swift
//  Data
//
//  Created by 유현진 on 6/10/24.
//

import Foundation
import Moya
import Domain

public enum LoginService{
    case loginKakao(LoginKakaoRequest)
}

extension LoginService: TargetType{
    public var baseURL: URL{
        return .init(string: "https://runninghi.store/api/v1")!
    }
    
    public var path: String{
        switch self{
        case .loginKakao: "/login/kakao"
        }
    }

    public var method: Moya.Method{
        switch self{
        case .loginKakao:
                .post
        }
    }
    
    public var task: Task{
        switch self{
        case .loginKakao(let request):
                .requestJSONEncodable(request)
        }
    }
    
    public var headers: [String : String]?{
        switch self{
        case .loginKakao:
            ["Content-Type": "application/json"]
        }
    }
}
