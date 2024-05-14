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

final class LoginReactor: Reactor{
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
    
    public var initialState: State = State()
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action{
        case .kakaoLogin:
            return Observable.concat([
                Observable.just(Mutation.setLoading(true)),
                kakaoLogin().map{Mutation.getKakaoToken($0)},
                Observable.just(Mutation.setLoading(false))
            ])
            
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
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
    
    var disposeBag = DisposeBag()
    
    func kakaoLogin() -> Observable<OAuthToken>{
        return Observable.create{ emitter in
            if UserApi.isKakaoTalkLoginAvailable(){
                UserApi.shared.rx.loginWithKakaoTalk()
                    .bind{ oAuthToken in
                        emitter.onNext(oAuthToken)
                        emitter.onCompleted()
                    }.disposed(by: self.disposeBag)
            }else{
                UserApi.shared.rx.loginWithKakaoAccount()
                    .bind{ oAuthToken in
                        emitter.onNext(oAuthToken)
                        emitter.onCompleted()
                    }.disposed(by: self.disposeBag)
            }
            return Disposables.create()
        }
    }
}
