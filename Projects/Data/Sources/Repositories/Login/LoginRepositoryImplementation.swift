//
//  LoginRepository.swift
//  Data
//
//  Created by 유현진 on 5/14/24.
//

import Foundation
import Domain
import KakaoSDKAuth
import RxKakaoSDKUser
import KakaoSDKUser
import RxSwift
import Moya
import RxMoya

public class LoginRepositoryImplementation: LoginRepositoryProtocol{

    private let service = MoyaProvider<LoginService>()
    
    public init(){
        
    }
    
    deinit{
        print("deinit LoginRepositoryImplementation")
    }
    
    public func kakaoLogin() -> Observable<OAuthToken>{
        return Observable.create{ emitter in
            let kakaoLoginObservable: Observable<OAuthToken>
            
            if UserApi.isKakaoTalkLoginAvailable(){
                kakaoLoginObservable = UserApi.shared.rx.loginWithKakaoTalk()
            }else{
                kakaoLoginObservable = UserApi.shared.rx.loginWithKakaoAccount()
            }
            
            let disposable = kakaoLoginObservable
                .subscribe(
                    onNext: { oAuthToken in
                        emitter.onNext(oAuthToken)
                        emitter.onCompleted()
                    },
                    onError: { error in
                        emitter.onError(error)
                    }
                )
            return Disposables.create{
                disposable.dispose()
            }
        }
    }
    
    
    
    public func requestWithKakaoToken(kakaoAccessToken: String) -> Observable<(String, String)>{
        return service.rx.request(.loginKakao(LoginKakaoRequest(kakaoToken: kakaoAccessToken)))
            .filterSuccessfulStatusCodes()
            .map{ response in
                let accessToken = response.response?.allHeaderFields["Authorization"] as! String
                let refreshToken = response.response?.allHeaderFields["Refresh-Token"] as! String
                print("[Request]")
                print("accessToken : \(accessToken)")
                print("refreshToken: \(refreshToken)")
                return (accessToken, refreshToken)
            }.asObservable()
    }
}

