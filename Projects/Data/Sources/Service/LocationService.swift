//
//  LocationService.swift
//  Data
//
//  Created by najin shin on 7/11/24.
//

import CoreLocation
import Foundation
import RxCocoa
import RxRelay
import RxSwift
import Domain

final class LocationService: NSObject {
    
    // MARK: - Properties
    
    var locationManager: CLLocationManager?
    
    var authorizationStatus = PublishSubject<CLAuthorizationStatus>()
    var motionManager = MotionManager()
    
    var disposeBag: DisposeBag = DisposeBag()
    
    // MARK: - Lifecycle
    
    override init() {
        super.init()
        
        self.locationManager = CLLocationManager()
        self.locationManager?.distanceFilter = CLLocationDistance(3)
        self.locationManager?.delegate = self
        self.locationManager?.desiredAccuracy = kCLLocationAccuracyBest
    }
    
    func observeUpdatedAuthorization() -> Observable<CLAuthorizationStatus> {
        return self.authorizationStatus.asObservable()
    }
    
    func requestAuthorization() {
        self.locationManager?.requestWhenInUseAuthorization()
    }
    
    func start() {
        self.locationManager?.startUpdatingLocation()
    }
    
    func stop() {
        self.locationManager?.stopUpdatingLocation()
    }
    
    func observeUpdatedLocation() -> Observable<[CLLocation]> {
        return PublishRelay<[CLLocation]>.create({ emitter in
            self.rx.methodInvoked(#selector(CLLocationManagerDelegate.locationManager(_:didUpdateLocations:)))
                .compactMap({ $0.last as? [CLLocation] })
                .subscribe(onNext: { location in
                    // 뛸 때만 위치기록 보내기
                    if self.motionManager.checkMotionActivity() != .stationary {
                        emitter.onNext(location)
                    }
                })
                .disposed(by: self.disposeBag)
            return Disposables.create()
        })
    }
}

extension LocationService: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {}
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        self.authorizationStatus.onNext(status)
    }
}
