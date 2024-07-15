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
import AuthenticationServices


public class LoginRepositoryImplementation: NSObject, LoginRepositoryProtocol{
    
    private let service = MoyaProvider<LoginService>()
    private var appleLoginEmitter: AnyObserver<(String, String)>?
    
    public override init() {
        super.init()
    }
    
    deinit{
        print("deinit LoginRepositoryImplementation")
    }
    
    public func loginWithKakao() -> Observable<OAuthToken>{
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
    
    public func signWithKakao(kakaoAccessToken: String) -> Observable<(String, String)>{
        return service.rx.request(.signWithKakao(SignWithKakao(kakaoToken: kakaoAccessToken)))
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
    
    public func signWithApple(requestModel: SignWithApple) -> Observable<(String, String)> {
        return service.rx.request(.signWithApple(requestModel))
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

extension LoginRepositoryImplementation: ASAuthorizationControllerDelegate{
    public func loginWithApple() -> Observable<(String, String)>{
        return Observable.create { emitter in
            
            let appleIDProvider = ASAuthorizationAppleIDProvider()
            let request = appleIDProvider.createRequest()
            request.requestedScopes = [.fullName, .email] //유저로 부터 알 수 있는 정보들(name, email)
            
            let authorizationController = ASAuthorizationController(authorizationRequests: [request])
            authorizationController.delegate = self
            authorizationController.presentationContextProvider = self
            self.appleLoginEmitter = emitter
            
            authorizationController.performRequests()
            
            return Disposables.create()
        }
    }
    
    public func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        switch authorization.credential{
        case let appleIDCredential as ASAuthorizationAppleIDCredential:
            if let authorizaionCode = appleIDCredential.authorizationCode,
               let identityToken = appleIDCredential.identityToken,
               let authCodeString = String(data: authorizaionCode, encoding: .utf8),
               let identityTokenString = String(data: identityToken, encoding: .utf8){
                
                appleLoginEmitter?.onNext((identityTokenString, authCodeString))
                appleLoginEmitter?.onCompleted()
            }
        default:
            break
        }
    }
    
    public func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        appleLoginEmitter?.onError(error)
    }
    
}

extension LoginRepositoryImplementation: ASAuthorizationControllerPresentationContextProviding {
    public func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        if let scene = UIApplication.shared.connectedScenes.first(where: { $0.activationState == .foregroundActive }) as? UIWindowScene {
            return scene.windows.first { $0.isKeyWindow } ?? UIWindow()
        }
        return UIWindow()
    }
}
