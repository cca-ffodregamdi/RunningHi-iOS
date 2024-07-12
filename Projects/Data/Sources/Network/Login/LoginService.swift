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
    case signWithKakao(SignWithKakao)
    case signWithApple(SignWithApple)
}

extension LoginService: TargetType{
    public var baseURL: URL{
        return .init(string: "https://runninghi.store/api/v1")!
    }
    
    public var path: String{
        switch self{
        case .signWithKakao: "/login/kakao"
        case .signWithApple: "/login/apple"
        }
    }

    public var method: Moya.Method{
        switch self{
        case .signWithKakao,
                .signWithApple:
                .post
        }
    }
    
    public var task: Task{
        switch self{
        case .signWithKakao(let request):
                .requestJSONEncodable(request)
        case .signWithApple(let request):
                .requestJSONEncodable(request)
        }
    }
    
    public var headers: [String : String]?{
        switch self{
        case .signWithKakao,
                .signWithApple:
            ["Content-Type": "application/json"]
        }
    }
}
