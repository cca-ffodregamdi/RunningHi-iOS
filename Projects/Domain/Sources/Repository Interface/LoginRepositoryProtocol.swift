//
//  SocialLoginManager.swift
//  Domain
//
//  Created by 유현진 on 5/14/24.
//

import Foundation
import RxSwift
import KakaoSDKAuth

public protocol LoginRepositoryProtocol{
    func loginWithKakao() -> Observable<OAuthToken>
    func signWithKakao(kakaoAccessToken: String) -> Observable<(String, String)>
    func signWithApple(requestModel: SignWithAppleRequestModel) -> Observable<(String, String)>
    func loginWithApple() -> Observable<(String, String)>
    func loginFromReviewer() -> Observable<(String, String)>
    
    func createKeyChain(key: KeyChainKeys, value: String)
    func readKeyChain(key: KeyChainKeys) -> String?
    func deleteKeyChain(key: KeyChainKeys)
    
    func setUserLocation(userLocationModel: UserLocation) -> Observable<Any>
    var authorizationStatus: PublishSubject<LocationAuthorizationStatus> { get }
    var currentUserLocation: PublishSubject<RouteInfo> { get }
    func checkUserCurrentLocationAuthorization()
    func startRunning()
    func stopRunning()
}
