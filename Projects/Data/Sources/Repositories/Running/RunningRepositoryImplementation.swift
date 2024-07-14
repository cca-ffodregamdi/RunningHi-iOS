//
//  RunningRepositoryImplementation.swift
//  Data
//
//  Created by najin on 7/7/24.
//

import Foundation
import Domain
import RxSwift
import CoreLocation

public class RunningRepositoryImplementation: RunningRepositoryProtocol {

    private let service = LocationService()
    
    public var authorizationStatus = PublishSubject<LocationAuthorizationStatus>()
    public var currentUserLocation = PublishSubject<RouteInfo>()
    
    var disposeBag: DisposeBag = DisposeBag()
    
    public init(){ }
    
    public func checkUserCurrentLocationAuthorization() {
        self.service.observeUpdatedAuthorization()
            .subscribe(onNext: { [weak self] status in
                switch status {
                case .notDetermined:
                    self?.service.requestAuthorization()
                case .authorizedAlways, .authorizedWhenInUse:
                    self?.authorizationStatus.onNext(.allowed)
                case .denied, .restricted:
                    self?.authorizationStatus.onNext(.disallowed)
                default:
                    self?.authorizationStatus.onNext(.notDetermined)
                }
            })
            .disposed(by: self.disposeBag)
    }
    
    public func startRunning() {
        service.start()
        observeUserLocation()
    }
    
    public func stopRunning() {
        service.stop()
        stopUpdatingLocation()
    }
    
    private func observeUserLocation() {
        self.service.observeUpdatedLocation()
            .compactMap({ $0.last })
            .subscribe(onNext: { [weak self] location in
                let route = RouteInfo(coordinate: location.coordinate)
                self?.currentUserLocation.onNext(route)
            })
            .disposed(by: self.disposeBag)
    }
    
    private func stopUpdatingLocation() {
        self.service.stop()
    }
}

