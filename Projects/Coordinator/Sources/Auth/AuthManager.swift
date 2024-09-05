//
//  AuthManager.swift
//  Coordinator
//
//  Created by 유현진 on 6/7/24.
//

import Foundation
import Moya
import RxMoya
import RxSwift
import Domain
import Data
import Common

public class AuthManager{
    public static let shared = AuthManager()
    
    private let service: MoyaProvider<AuthService>
    
    static var isReviewer: Bool = false
    
    public init(){
        let authPlugIn = AccessTokenPlugin { _ in
            return KeyChainManager.read(key: .runningHiAccessTokenkey)!
        }
        service = MoyaProvider<AuthService>(plugins: [authPlugIn])
    }
    
    
    public func isValidAccessToken() -> Observable<Bool>{
        return service.rx.request(.isValidAccessToken)
            .asObservable()
            .flatMap{ [weak self] response -> Observable<Bool> in
                let accessResponse = try JSONDecoder().decode(AccessTokenValidationResponseDTO.self, from: response.data)
                if accessResponse.data == true{
                    print("액세스 토큰 검증 성공")
                    return Observable.just(true)
                }else if accessResponse.data == false{
                    print("액세스토큰 만료")
                    return self!.isValidRefreshToken()
                }else{
                    print("액세스 토큰 검증 실패")
                    return Observable.just(false)
                }
            }
    }
    
    public func isValidRefreshToken() -> Observable<Bool>{
        return service.rx.request(.isValidRefreshToken)
            .map{ response in
                let refreshReponse = try JSONDecoder().decode(RefreshTokenValidationResponseDTO.self, from: response.data)
                if refreshReponse.data == true{
                    let accessToken = response.response?.allHeaderFields["Authorization"] as? String
                    KeyChainManager.create(key: .runningHiAccessTokenkey, token: accessToken!)
                    return true
                }else{
                    return false
                }
            }.asObservable()
    }
    
    public func isReviewerVersion() -> Observable<Void>{
        if let dictionary = Bundle.main.infoDictionary, let version = dictionary["CFBundleShortVersionString"] as? String {
            return service.rx.request(.isReviewerVersion(version))
                .map{ response in
                    let responseData = try JSONDecoder().decode(CheckReviewerResponseDTO.self, from: response.data)
                    AuthManager.isReviewer = responseData.data?.isReviewer ?? false
                    return
                }.asObservable()
        } else {
            return Observable.just(())
        }
    }
}

