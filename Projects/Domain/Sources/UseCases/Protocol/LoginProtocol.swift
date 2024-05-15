//
//  LoginProtocol.swift
//  Domain
//
//  Created by 유현진 on 5/14/24.
//

import Foundation
import RxSwift
import KakaoSDKAuth

protocol LoginProtocol{
    func login() -> Single<OAuthToken>
}
