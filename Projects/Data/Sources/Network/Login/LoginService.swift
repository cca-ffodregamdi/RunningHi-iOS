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
    case setUserLocation(UserLocation)
}

extension LoginService: TargetType{
    public var baseURL: URL{
        return .init(string: "https://runninghi.store/api/v1")!
    }
    
    public var accessToken: String{
        return KeyChainManager.read(key: .runningHiAccessTokenkey)!
    }
    
    public var path: String{
        switch self{
        case .signWithKakao: "/login/kakao"
        case .signWithApple: "/login/apple"
        case .setUserLocation:  "/member/geometry"
        }
    }

    public var method: Moya.Method{
        switch self{
        case .signWithKakao,
                .signWithApple:
                .post
        case .setUserLocation:
                .put
        }
    }
    
    public var task: Task{
        switch self{
        case .signWithKakao(let request):
                .requestJSONEncodable(request)
        case .signWithApple(let request):
                .requestJSONEncodable(request)
        case .setUserLocation(let request):
                .requestJSONEncodable(request)
        }
    }
    
    public var headers: [String : String]?{
        switch self{
        case .signWithKakao,
                .signWithApple:
            return ["Content-Type": "application/json"]
        case .setUserLocation:
            return ["Content-type": "application/json",
                    "Authorization": accessToken]
        }
    }
}
