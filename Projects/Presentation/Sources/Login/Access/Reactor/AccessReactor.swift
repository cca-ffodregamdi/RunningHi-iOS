//
//  AccessReactor.swift
//  Presentation
//
//  Created by 유현진 on 8/7/24.
//

import Foundation
import RxSwift
import ReactorKit
import Domain
import Common

public class AccessReactor: Reactor{
    public enum Action{
        case checkRow(Int)
        case touchUpCheckAllButton
        case signIn
    }
    
    public enum Mutation{
        case changeCheckArray(Int)
        case checkAllToggle
        case signed(String, String)
    }
    
    public struct State{
        let accessModel: [String] = ["서비스 이용 약관 (필수)", "개인정보 수집/이용 동의서 (필수)"]
        var checkArray: [Bool] = [false, false]
        var checkAllState: Bool = false
        var successedSignIn: Bool = false
    }
    
    public var initialState: State
    private let loginUseCase: LoginUseCase
    
    public init(loginUseCase: LoginUseCase) {
        self.initialState = State()
        self.loginUseCase = loginUseCase
    }
    
    public func mutate(action: Action) -> Observable<Mutation> {
        switch action{
        case .checkRow(let index):
            return Observable.just(Mutation.changeCheckArray(index))//.observe(on: MainScheduler.asyncInstance)
        case .touchUpCheckAllButton:
            return Observable.just(Mutation.checkAllToggle)//.observe(on: MainScheduler.asyncInstance)
            
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
        case .changeCheckArray(let index):
            newState.checkArray[index].toggle()
        case .checkAllToggle:
            newState.checkAllState.toggle()
            newState.checkArray[0] = newState.checkAllState
            newState.checkArray[1] = newState.checkAllState
        case .signed(let accessToken, let refreshToken):
            loginUseCase.createKeyChain(key: .runningHiAccessTokenkey, value: accessToken)
            loginUseCase.createKeyChain(key: .runningHiRefreshTokenKey, value: refreshToken)
            newState.successedSignIn = true
        }
        return newState
    }
}
