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
    case signWithKakao(SignWithKakaoRequestModel)
    case signWithApple(SignWithAppleRequestModel)
    case loginFromReviewer
    case setUserLocation(UserLocation)
    case fetchTermsAgreement
    case setTermsAgreement
}

extension LoginService: TargetType{
    public var baseURL: URL{
        switch self {
        case .loginFromReviewer:
            return .init(string: "https://runninghi.store")!
        default:
            return .init(string: "https://runninghi.store/api/v1")!
        }
    }
    
    public var accessToken: String{
        return KeyChainManager.read(key: .runningHiAccessTokenkey)!
    }
    
    public var path: String{
        switch self{
        case .signWithKakao: "/login/kakao"
        case .signWithApple: "/login/apple"
        case .setUserLocation:  "/member/geometry"
        case .loginFromReviewer: "/test/token"
        case .fetchTermsAgreement: "/member/terms-agreement"
        case .setTermsAgreement: "/member/terms-agreement/consent"
        }
    }

    public var method: Moya.Method{
        switch self{
        case .signWithKakao,
            .signWithApple,
            .loginFromReviewer:
                .post
        case .setUserLocation,
                .setTermsAgreement:
                .put
        case .fetchTermsAgreement:
                .get
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
        case .loginFromReviewer,
                .fetchTermsAgreement,
                .setTermsAgreement:
                .requestPlain
        }
    }
    
    public var headers: [String : String]?{
        switch self{
        case .signWithKakao,
                .signWithApple,
                .setTermsAgreement:
            return ["Content-Type": "application/json"]
        case .setUserLocation,
                .fetchTermsAgreement:
            return ["Content-type": "application/json",
                    "Authorization": accessToken]
        case .loginFromReviewer:
            return nil
        }
    }
}
