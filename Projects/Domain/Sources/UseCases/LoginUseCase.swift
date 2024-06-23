//
//  LoginUseCase.swift
//  Domain
//
//  Created by 유현진 on 5/14/24.
//

import Foundation
import RxSwift
import KakaoSDKAuth

final public class LoginUseCase: LoginUseCaseProtocol{
    private let loginRepository: LoginRepositoryProtocol
    
    public init(loginRepository: LoginRepositoryProtocol) {
        self.loginRepository = loginRepository
    }
    
    public func login() -> Observable<OAuthToken>{
        return loginRepository.login()
    }
    
    public func requestWithKakaoToken(kakaoAccessToken: String) -> Observable<(String, String)>{
        return loginRepository.requestWithKakaoToken(kakaoAccessToken: kakaoAccessToken)
    }
}

