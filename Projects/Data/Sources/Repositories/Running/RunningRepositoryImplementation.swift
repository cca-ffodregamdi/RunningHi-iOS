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
import Moya
import RxMoya

public class RunningRepositoryImplementation: RunningRepositoryProtocol {

    private let locationService = LocationService()
    private let networkService = MoyaProvider<RunningService>()
    
    public var authorizationStatus = PublishSubject<LocationAuthorizationStatus>()
    public var currentUserLocation = PublishSubject<RouteInfo>()
    
    var disposeBag: DisposeBag = DisposeBag()
    
    public init(){ }
    
    public func checkUserCurrentLocationAuthorization() {
        self.locationService.observeUpdatedAuthorization()
            .subscribe(onNext: { [weak self] status in
                switch status {
                case .notDetermined:
                    self?.locationService.requestAuthorization()
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
        locationService.start()
        observeUserLocation()
    }
    
    public func stopRunning() {
        locationService.stop()
        stopUpdatingLocation()
    }
    
    public func saveRunningResult(runningResult: RunningResult) -> Observable<Any> {
        let runningResultDTO = RunningResultDTO.fromEntity(data: runningResult)
        
        var request_data = ""
        do {
            let jsonData = try JSONEncoder().encode(runningResultDTO)
            if let jsonString = String(data: jsonData, encoding: .utf8) {
                request_data = jsonString
                print(jsonString)
            }
        } catch {
            return Observable.error(error)
        }
        
        return networkService.rx.request(.saveRunningResult(data: request_data))
            .filterSuccessfulStatusCodes()
            .map{ response in
                return Observable.just(())
            }.asObservable()
            .catch{ error in
                print(error)
                return Observable.error(error)
            }
    }
    
    //MARK: - Helpers
    
    private func observeUserLocation() {
        self.locationService.observeUpdatedLocation()
            .compactMap({ $0.last })
            .subscribe(onNext: { [weak self] location in
                let route = RouteInfo(coordinate: location.coordinate)
                self?.currentUserLocation.onNext(route)
            })
            .disposed(by: self.disposeBag)
    }
    
    private func stopUpdatingLocation() {
        self.locationService.stop()
    }
}
