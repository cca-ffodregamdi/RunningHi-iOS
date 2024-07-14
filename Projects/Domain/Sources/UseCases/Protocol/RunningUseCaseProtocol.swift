//
//  RunningUseCaseProtocol.swift
//  Domain
//
//  Created by najin on 7/7/24.
//

import Foundation
import RxSwift
import KakaoSDKAuth

protocol RunningUseCaseProtocol{
    func checkUserCurrentLocationAuthorization() -> Observable<LocationAuthorizationStatus>
    
    func startRunning()
    func stopRunning()
}
