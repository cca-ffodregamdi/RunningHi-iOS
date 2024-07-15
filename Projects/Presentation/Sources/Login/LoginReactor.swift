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
    }
    
    public enum Mutation{
        case signed(String, String)
        case setLoading(Bool)
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
                    .flatMap{ token -> Observable<(String, String)> in
                        return self.loginUseCase.signWithKakao(kakaoAccessToken: token.accessToken)
                    }
                    .flatMap{ accessToken, refreshToken -> Observable<Mutation> in
                        return Observable.just(Mutation.signed(accessToken, refreshToken))
                    }.catchAndReturn(Mutation.setLoading(false)),
                Observable.just(Mutation.setLoading(false))
            ])
        case .appleLogin:
            return Observable.concat([
                Observable.just(Mutation.setLoading(true)),
                loginUseCase.loginWithApple()
                    .flatMap { identityToken, authorizationCode -> Observable<(String, String)> in
                        self.loginUseCase.signWithApple(requestModel: SignWithApple(authorizationCode: authorizationCode, identityCode: identityToken))
                    }.flatMap{ accessToken, refreshToken -> Observable<Mutation> in
                        return Observable.just(Mutation.signed(accessToken, refreshToken))
                    }.catchAndReturn(Mutation.setLoading(false)),
                Observable.just(Mutation.setLoading(false))
            ])
        }
    }
    
    public func reduce(state: State, mutation: Mutation) -> State {
        var state = state
        switch mutation{
        case .signed(let accessToken, let refreshToken):
            UserDefaults.standard.setValue(accessToken, forKey: "accessToken")
            UserDefaults.standard.setValue(refreshToken, forKey: "refreshToken")
            state.successed = true
        case .setLoading(let value):
            state.isLoading = value
        }
        return state
    }
}
