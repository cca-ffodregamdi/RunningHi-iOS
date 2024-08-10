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
        let accessModel: [String] = ["서비스 이용 약관 (필수)", "개인정보 수집/이용 동의서 (필수)", "위치정보 이용약관 (필수)"]
        var checkArray: [Bool] = [false, false, false]
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
            return Observable.just(Mutation.changeCheckArray(index))
        case .touchUpCheckAllButton:
            return Observable.just(Mutation.checkAllToggle)
        case .signIn:
            if let loginTypeRawValue = UserDefaultsManager.get(forKey: .loginTypeKey) as? String{
                if let loginType = LoginType(rawValue: loginTypeRawValue){
                    switch loginType{
                    case .apple:
                        return loginUseCase.signWithApple(requestModel: .init(authorizationCode: KeyChain.read(key: .appleLoginAuthorizationCodeKey) ?? "", identityToken: KeyChain.read(key: .appleLoginIdentityTokenKey) ?? "")).map{ Mutation.signed($0, $1)}
                    case .kakao:
                        return loginUseCase.signWithKakao(kakaoAccessToken: KeyChain.read(key: .kakaoLoginAccessTokenKey) ?? "").map{ Mutation.signed($0, $1) }
                    }
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
            newState.checkArray[2] = newState.checkAllState
        case .signed(let accessToken, let refreshToken):
            UserDefaults.standard.setValue(accessToken, forKey: "accessToken")
            UserDefaults.standard.setValue(refreshToken, forKey: "refreshToken")
            newState.successedSignIn = true
        }
        return newState
    }
}
