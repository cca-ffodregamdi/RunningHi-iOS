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
    }
    
    enum Mutation {
        case setCoordinates([CLLocationCoordinate2D])
        case setRunning(Bool)
        case setCurrentLocation(CLLocationCoordinate2D)
        case moveToCurrentLocation(CLLocationCoordinate2D)
    }
    
    struct State {
        var coordinates: [CLLocationCoordinate2D] = []
        var isRunning: Bool = false
        var currentLocation: CLLocationCoordinate2D?
        var moveToLocation: CLLocationCoordinate2D?
    }
    
    let initialState = State()
    private let locationManager = LocationManager.shared
    private let timer = Observable<Int>.interval(.seconds(5), scheduler: MainScheduler.instance)
    private let disposeBag = DisposeBag()
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .startRunningCourse:
            return startRunningCourse()
        case .stopRunningCourse:
            locationManager.stopLocationUpdates()
            return Observable.just(Mutation.setRunning(false))
        case .moveToCurrentLocation:
            guard let currentLocation = locationManager.location?.coordinate else {
                return Observable.empty()
            }
            return Observable.just(Mutation.moveToCurrentLocation(currentLocation))
        }
    }
    
    private func startRunningCourse() -> Observable<Mutation> {
        locationManager.startLocationUpdates()
        
        let locationObservable = locationManager.rx.didUpdateLocations
            .map { $0.last?.coordinate }
            .compactMap { $0 }
            .map(Mutation.setCurrentLocation)
        
        let timerObservable = timer
            .withLatestFrom(locationManager.rx.didUpdateLocations)
            .map { $0.map { $0.coordinate } }
            .distinctUntilChanged()
            .map(Mutation.setCoordinates)
        
        return Observable.merge(
            Observable.just(Mutation.setRunning(true)),
            locationObservable,
            timerObservable
        )
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        switch mutation {
        case .setCoordinates(let coordinates):
            newState.coordinates.append(contentsOf: coordinates)
        case .setRunning(let isRunning):
            newState.isRunning = isRunning
        case .setCurrentLocation(let location):
            newState.currentLocation = location
        case .moveToCurrentLocation(let location):
            newState.moveToLocation = location
        }
        return newState
    }
}
