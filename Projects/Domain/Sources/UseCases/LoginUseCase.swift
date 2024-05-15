//
//  LoginUseCase.swift
//  Domain
//
//  Created by 유현진 on 5/14/24.
//

import Foundation
import RxSwift
import KakaoSDKAuth

final public class LoginUseCase: LoginProtocol{
    private let loginRepository: LoginRepositoryProtocol
    
    init(loginRepository: LoginRepositoryProtocol) {
        self.loginRepository = loginRepository
    }
    
    public func login() -> Single<OAuthToken>{
        return loginRepository.login()
    }
}
