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
    
    var disposeBag: DisposeBag = DisposeBag()
    
    public func login() -> Single<OAuthToken>{
        return Single.create{ emitter in
            if UserApi.isKakaoTalkLoginAvailable(){
                UserApi.shared.rx.loginWithKakaoTalk().asSingle()
                    .subscribe(
                        onSuccess: {oAuthToken in
                            emitter(.success(oAuthToken))
                        },
                        onFailure: { error in
                            emitter(.failure(error))
                        },
                        onDisposed: {
                            print("disposed")
                        }
                    )
                    .disposed(by: self.disposeBag)
            }else{
                UserApi.shared.rx.loginWithKakaoAccount().asSingle()
                    .subscribe(
                        onSuccess: {oAuthToken in
                            emitter(.success(oAuthToken))
                        },
                        onFailure: { error in
                            emitter(.failure(error))
                        }
                    ).disposed(by: self.disposeBag)
            }
            return Disposables.create()
        }
    }
}
