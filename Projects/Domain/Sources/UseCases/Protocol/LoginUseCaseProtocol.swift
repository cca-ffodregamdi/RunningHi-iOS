//
//  LoginProtocol.swift
//  Domain
//
//  Created by 유현진 on 5/14/24.
//

import Foundation
import RxSwift
import KakaoSDKAuth

protocol LoginUseCaseProtocol{
    func loginWithKakao() -> Observable<OAuthToken>
    func signWithKakao(kakaoAccessToken: String) -> Observable<(String, String)>
    func signWithApple(requestModel: SignWithApple) -> Observable<(String, String)>
    func loginWithApple() -> Observable<(String, String)>
    func setUserLocation(userLocationModel: UserLocation) -> Observable<Any>
    func checkUserCurrentLocationAuthorization() -> Observable<LocationAuthorizationStatus>
    func getUserLocation() -> Observable<RouteInfo>
    func startRunning()
    func stopRunning()
}
