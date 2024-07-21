//
//  RunningUseCaseProtocol.swift
//  Domain
//
//  Created by najin on 7/7/24.
//

import Foundation
import RxSwift
import KakaoSDKAuth

public protocol RunningUseCaseProtocol{
    func checkUserCurrentLocationAuthorization() -> Observable<LocationAuthorizationStatus>
    
    func startRunning()
    func stopRunning()
    
    func saveRunningResult(runningResult: RunningResult) -> Observable<Any>
}
