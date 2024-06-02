//
//  RunningCourseReactor.swift
//  Presentation
//
//  Created by 오영석 on 5/11/24.
//

import ReactorKit
import RxSwift
import CoreLocation

final class RunningCourseReactor: Reactor {
    
    enum Action {
        case startRunningCourse
        case stopRunningCourse
        case moveToCurrentLocation
        case initializeLocation
    }
    
    enum Mutation {
        case setRouteInfo([RouteInfo])
        case setRunning(Bool)
        case setCurrentLocation(CLLocationCoordinate2D)
        case moveToCurrentLocation(CLLocationCoordinate2D)
        case setStartLocation(CLLocationCoordinate2D)
        case setStopLocation(CLLocationCoordinate2D)
        case clearCourse
    }
    
    struct State {
        var routeInfos: [RouteInfo] = []
        var isRunning: Bool = false
        var currentLocation: CLLocationCoordinate2D?
        var moveToLocation: CLLocationCoordinate2D?
        var startLocation: CLLocationCoordinate2D?
        var stopLocation: CLLocationCoordinate2D?
    }
    
    let initialState = State()
    private let locationManager = LocationManager.shared
    private let disposeBag = DisposeBag()
    private var lastLocation: CLLocationCoordinate2D?
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .startRunningCourse:
            return Observable.concat([
                Observable.just(Mutation.clearCourse),
                startRunningCourse()
            ])
        case .stopRunningCourse:
            return stopRunningCourse()
        case .moveToCurrentLocation:
            let currentLocation = LocationManager.routeInfo.coordinate
            return Observable.just(Mutation.moveToCurrentLocation(currentLocation))
        case .initializeLocation:
            return initializeLocation()
        }
    }
    
    private func initializeLocation() -> Observable<Mutation> {
        return locationManager.rx.didUpdateLocations
            .map { $0.last?.coordinate }
            .compactMap { $0 }
            .take(1)
            .map { Mutation.setCurrentLocation($0) }
    }
    
    private func startRunningCourse() -> Observable<Mutation> {
        locationManager.startLocationUpdates()
        lastLocation = nil
        locationManager.isStartRunning = true
        let locationObservable = locationManager.didUpdateLocationsSubject
            .map { $0.last }
            .compactMap { $0 }
            .flatMapLatest { [currentState = self.currentState] newLocation -> Observable<Mutation> in
                var updatedRouteInfos = currentState.routeInfos
                let newRouteInfo = RouteInfo(latitude: newLocation.coordinate.latitude, longitude: newLocation.coordinate.longitude, timestamp: Date())
                updatedRouteInfos.append(newRouteInfo)
                self.lastLocation = newLocation.coordinate
                return Observable.just(Mutation.setRouteInfo(updatedRouteInfos))
            }

        let startLocationObservable = locationManager.didUpdateLocationsSubject
            .map { $0.last }
            .compactMap { $0 }
            .take(1)
            .map { location in
                Mutation.setStartLocation(location.coordinate)
            }

        return Observable.merge(
            Observable.just(Mutation.setRunning(true)),
            startLocationObservable,
            locationObservable
        )
    }
    
    private func stopRunningCourse() -> Observable<Mutation> {
        locationManager.stopLocationUpdates()
        locationManager.isStartRunning = false
        
        let lastLocation = LocationManager.routeInfo.coordinate
        let stopLocationMutation = Observable.just(Mutation.setStopLocation(lastLocation))
        let routeInfoMutation = Observable.just(Mutation.setRouteInfo(currentState.routeInfos))
        
        return Observable.concat([
            stopLocationMutation,
            routeInfoMutation,
            Observable.just(Mutation.setRunning(false))
        ])
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        switch mutation {
        case .setRouteInfo(let routeInfos):
            newState.routeInfos = routeInfos
        case .setRunning(let isRunning):
            newState.isRunning = isRunning
        case .setCurrentLocation(let location):
            newState.currentLocation = location
        case .moveToCurrentLocation(let location):
            newState.moveToLocation = location
        case .setStartLocation(let location):
            newState.startLocation = location
        case .setStopLocation(let location):
            newState.stopLocation = location
        case .clearCourse:
            newState.routeInfos = []
            newState.startLocation = nil
            newState.stopLocation = nil
        }
        return newState
    }
}
