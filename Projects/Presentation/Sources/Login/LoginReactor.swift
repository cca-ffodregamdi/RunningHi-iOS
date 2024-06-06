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
    }
    
    public enum Mutation{
        case getKakaoToken(OAuthToken)
        case setLoading(Bool)
    }
    
    public struct State{
        var isLoading: Bool
        var successed: Bool
        var kakaoOAuthToken: OAuthToken?
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
                loginUseCase.login()
                    .asObservable()
                    .flatMap{ token -> Observable<Mutation> in
                        return Observable.just( Mutation.getKakaoToken(token))
                    }.catchAndReturn(Mutation.setLoading(false)),
                Observable.just(Mutation.setLoading(false))
            ])
        }
    }
    
    public func reduce(state: State, mutation: Mutation) -> State {
        var state = state
        switch mutation{
        case .getKakaoToken(let token):
            state.kakaoOAuthToken = token
            if state.kakaoOAuthToken != nil{
                state.successed = true
            }
        case .setLoading(let value):
            state.isLoading = value
        }
        return state
    }
}
