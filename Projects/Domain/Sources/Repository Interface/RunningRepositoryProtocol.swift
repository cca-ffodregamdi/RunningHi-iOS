//
//  RunningRepositoryProtocol.swift
//  Domain
//
//  Created by najin on 7/7/24.
//

import Foundation
import RxSwift
import KakaoSDKAuth

public protocol RunningRepositoryProtocol{
    var authorizationStatus: PublishSubject<LocationAuthorizationStatus> { get }
    var currentUserLocation: PublishSubject<RouteInfo> { get }
    
    func checkUserCurrentLocationAuthorization()
    func startRunning()
    func stopRunning()
}
