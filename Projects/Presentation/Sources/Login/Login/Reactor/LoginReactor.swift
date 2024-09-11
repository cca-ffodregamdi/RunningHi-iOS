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
import Common

final public class LoginReactor: Reactor{
    
    public enum Action{
        case kakaoLogin
        case appleLogin
        case reviewerLogin
        case resetSuccessed
        case signIn
    }
    
    public enum Mutation{
        case setLoading(Bool)
        case resetSuccessed(Bool)
        case successdKakaoLogin(String, Bool)
        case successedAppleLogin(String, String, Bool)
        case successedReviewerLogin(String)
        case signed(String, String)
    }
    
    public struct State{
        var isLoading: Bool = false
        var successed: Bool = false
        var isTermsAgreed: Bool?
        var successedSignIn: Bool = false
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
                Observable.zip(loginUseCase.loginWithKakao(), loginUseCase.fetchIsTermsAgreement())
                    .map{ token, isTermsAgreed in
                        return Mutation.successdKakaoLogin(token.accessToken, isTermsAgreed)
                    },
                Observable.just(Mutation.setLoading(false))
            ])
        case .appleLogin:
            return Observable.concat([
                Observable.just(Mutation.setLoading(true)),
                Observable.zip(loginUseCase.loginWithApple(), loginUseCase.fetchIsTermsAgreement())
                    .map{ appleResponse, isTermsAgreed in
                        let identityToken = appleResponse.0
                        let authorizationCode = appleResponse.1
                        return Mutation.successedAppleLogin(identityToken, authorizationCode, isTermsAgreed)
                    },
                Observable.just(Mutation.setLoading(false))
            ])
        case .reviewerLogin:
            return loginUseCase.loginFromReviewer()
                .map { accessToken, refreshToken in
                    Mutation.successedReviewerLogin(accessToken)
                }
        case .resetSuccessed:
            return Observable.just(Mutation.resetSuccessed(false))
        case .signIn:
            if let loginType = LoginType(rawValue:
                                            UserDefaultsManager.get(forKey: .loginTypeKey) as! String){
                switch loginType{
                case .apple:
                    return loginUseCase.signWithApple(requestModel: .init(authorizationCode: loginUseCase.readKeyChain(key: .appleLoginAuthorizationCodeKey) ?? "", identityToken: loginUseCase.readKeyChain(key: .appleLoginIdentityTokenKey) ?? "")).map{ Mutation.signed($0, $1)}
                case .kakao:
                    return loginUseCase.signWithKakao(kakaoAccessToken: loginUseCase.readKeyChain(key: .kakaoLoginAccessTokenKey) ?? "").map{Mutation.signed($0, $1)}
                }
            }
            return Observable.empty()
        }
    }
    
    public func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        switch mutation{
        case .setLoading(let value):
            newState.isLoading = value
        case .resetSuccessed(let value):
            newState.successed = value
        case .successdKakaoLogin(let kakaoAccessToken, let isTermsAgreed):
            UserDefaultsManager.set(to: LoginType.kakao.rawValue, forKey: .loginTypeKey)
            loginUseCase.createKeyChain(key: .kakaoLoginAccessTokenKey, value: kakaoAccessToken)
            newState.successed = true
            newState.isTermsAgreed = isTermsAgreed
        case .successedAppleLogin(let identityToken, let authorizationCode, let isTermsAgreed):
            UserDefaultsManager.set(to: LoginType.apple.rawValue, forKey: .loginTypeKey)
            loginUseCase.createKeyChain(key: .appleLoginIdentityTokenKey, value: identityToken)
            loginUseCase.createKeyChain(key: .appleLoginAuthorizationCodeKey, value: authorizationCode)
            newState.successed = true
            newState.isTermsAgreed = isTermsAgreed
        case .successedReviewerLogin(let accessToken):
            loginUseCase.createKeyChain(key: .runningHiAccessTokenkey, value: accessToken)
            newState.successed = true
        case .signed(let accessToken, let refreshToken):
            loginUseCase.createKeyChain(key: .runningHiAccessTokenkey, value: accessToken)
            loginUseCase.createKeyChain(key: .runningHiRefreshTokenKey, value: refreshToken)
            newState.successedSignIn = true
        }
        return newState
    }
}
