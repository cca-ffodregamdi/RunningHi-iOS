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
    func kakaoLogin() -> Observable<OAuthToken>
    func requestWithKakaoToken(kakaoAccessToken: String) -> Observable<(String, String)>
}
