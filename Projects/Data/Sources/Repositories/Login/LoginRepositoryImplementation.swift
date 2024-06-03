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

public class LoginRepositoryImplementation: LoginRepositoryProtocol{

    public init(){
        
    }
    
    deinit{
        print("deinit LoginRepositoryImplementation")
    }
    
    public func login() -> Observable<OAuthToken>{
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
}

