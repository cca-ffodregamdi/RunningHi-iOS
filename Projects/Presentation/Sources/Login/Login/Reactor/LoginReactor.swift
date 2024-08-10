//
//  LoginReactor.swift
//  Presentation
//
//  Created by 유현진 on 5/4/24.
//

import Foundation
import RxSwift
import ReactorKit
import KakaoSDKAuth
import KakaoSDKUser
import RxKakaoSDKAuth
import RxKakaoSDKUser
import KakaoSDKCommon
import Domain

final public class LoginReactor: Reactor{
    
    public enum Action{
        case kakaoLogin
        case appleLogin
        case resetSuccessed
    }
    
    public enum Mutation{
        case setLoading(Bool)
        case resetSuccessed(Bool)
        case successdKakaoLogin(String)
        case successedAppleLogin(String, String)
    }
    
    public struct State{
        var isLoading: Bool
        var successed: Bool
        init() {
            isLoading = false
            successed = false
        }
    }
    
    public let initialState: State
    private let loginUseCase: LoginUseCase
    
    public init(loginUseCase: LoginUseCase) {
        self.initialState = State()
        self.loginUseCase = loginUseCase
    }
    
    public func mutate(action: Action) -> Observable<Mutation> {
        switch action{
        case .kakaoLogin:
            return Observable.concat([
                Observable.just(Mutation.setLoading(true)),
                loginUseCase.loginWithKakao()
                    .map{ token in
                        Mutation.successdKakaoLogin(token.accessToken)
                    }.catchAndReturn(Mutation.setLoading(false)),
                Observable.just(Mutation.setLoading(false))
            ])
        case .appleLogin:
            return Observable.concat([
                Observable.just(Mutation.setLoading(true)),
                loginUseCase.loginWithApple()
                    .map { identityToken, authorizationCode in
                        Mutation.successedAppleLogin(identityToken, authorizationCode)
                    }.catchAndReturn(Mutation.setLoading(false)),
                Observable.just(Mutation.setLoading(false))
            ])
        case .resetSuccessed:
            return Observable.just(Mutation.resetSuccessed(false))
        }
    }
    
    public func reduce(state: State, mutation: Mutation) -> State {
        var state = state
        switch mutation{
        case .setLoading(let value):
            state.isLoading = value
        case .resetSuccessed(let value):
            state.successed = value
        case .successdKakaoLogin(let kakaoAccessToken):
            UserDefaultsManager.set(to: LoginType.kakao.rawValue, forKey: .loginTypeKey)
            KeyChain.create(key: .kakaoLoginAccessTokenKey, token: kakaoAccessToken)
            state.successed = true
        case .successedAppleLogin(let identityToken, let authorizationCode):
            UserDefaultsManager.set(to: LoginType.apple.rawValue, forKey: .loginTypeKey)
            KeyChain.create(key: .appleLoginIdentityTokenKey, token: identityToken)
            KeyChain.create(key: .appleLoginAuthorizationCodeKey, token: authorizationCode)
            state.successed = true
        }
        return state
    }
}
