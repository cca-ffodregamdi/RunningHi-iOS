//
//  LoginUseCase.swift
//  Domain
//
//  Created by 유현진 on 5/14/24.
//

import Foundation
import RxSwift
import KakaoSDKAuth

final public class LoginUseCase: LoginUseCaseProtocol{
    private let loginRepository: LoginRepositoryProtocol
    
    public init(loginRepository: LoginRepositoryProtocol) {
        self.loginRepository = loginRepository
    }
    
    public func loginWithKakao() -> Observable<OAuthToken>{
        return loginRepository.loginWithKakao()
    }
    
    public func signWithKakao(kakaoAccessToken: String) -> Observable<(String, String)>{
        return loginRepository.signWithKakao(kakaoAccessToken: kakaoAccessToken)
    }
    
    public func signWithApple(requestModel: SignWithAppleRequestModel) -> Observable<(String, String)> {
        return loginRepository.signWithApple(requestModel: requestModel)
    }
    
    public func loginWithApple() -> Observable<(String, String)> {
        return loginRepository.loginWithApple()
    }
    
    public func loginFromReviewer() -> Observable<(String, String)> {
        return loginRepository.loginFromReviewer()
    }
    
    public func checkUserCurrentLocationAuthorization() -> Observable<LocationAuthorizationStatus> {
        self.loginRepository.checkUserCurrentLocationAuthorization()
        
        return loginRepository.authorizationStatus
            .asObservable()
    }
    
    public func getUserLocation() -> Observable<RouteInfo> {
        return loginRepository.currentUserLocation
            .asObservable()
    }
    
    public func startRunning() {
        self.loginRepository.startRunning()
    }
    
    public func stopRunning() {
        self.loginRepository.stopRunning()
    }
    
    public func setUserLocation(userLocationModel: UserLocation) -> Observable<Any> {
        return loginRepository.setUserLocation(userLocationModel: userLocationModel)
    }
    
    public func createKeyChain(key: KeyChainKeys, value: String) {
        return loginRepository.createKeyChain(key: key, value: value)
    }
    
    public func readKeyChain(key: KeyChainKeys) -> String? {
        return loginRepository.readKeyChain(key: key)
    }
    
    public func deleteKeyChain(key: KeyChainKeys) {
        return loginRepository.deleteKeyChain(key: key)
    }
    
    public func fetchIsTermsAgreement() -> Observable<Bool> {
        return loginRepository.fetchIsTermsAgreement()
    }
    
    public func setTermsAgreement() -> Observable<Any> {
        return loginRepository.setTermsAgreement()
    }
}

