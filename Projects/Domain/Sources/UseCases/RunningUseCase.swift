//
//  RunningUseCase.swift
//  Domain
//
//  Created by najin on 7/7/24.
//

import Foundation
import RxSwift

public final class RunningUseCase: RunningUseCaseProtocol {
    
    private let repository: RunningRepositoryProtocol
    
    private let disposeBag = DisposeBag()

    public init(repository: RunningRepositoryProtocol) {
        self.repository = repository
    }
    
    public func checkUserCurrentLocationAuthorization() -> Observable<LocationAuthorizationStatus> {
        self.repository.checkUserCurrentLocationAuthorization()
        
        return repository.authorizationStatus
            .asObservable()
    }
    
    public func getUserLocation() -> Observable<RouteInfo> {
        return repository.currentUserLocation
            .asObservable()
    }
    
    public func startRunning() {
        self.repository.startRunning()
    }
    
    public func stopRunning() {
        self.repository.stopRunning()
    }
    
    public func saveRunningResult(runningResult: RunningResult) -> Observable<Int> {
        return self.repository.saveRunningResult(runningResult: runningResult)
    }
}
