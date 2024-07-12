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
    
    public func loginWithKakao() -> Observable<OAuthToken>{
        return loginRepository.loginWithKakao()
    }
    
    public func signWithKakao(kakaoAccessToken: String) -> Observable<(String, String)>{
        return loginRepository.signWithKakao(kakaoAccessToken: kakaoAccessToken)
    }
    
    public func signWithApple(requestModel: SignWithApple) -> Observable<(String, String)> {
        return loginRepository.signWithApple(requestModel: requestModel)
    }
}

